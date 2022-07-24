---
title: Best Practices To Write A Makefile
categories: programming
tags:
  - makefile
---

I read these two blogs on Makefiles:
[An opinionated approach to (GNU) Make][1] and
[Tips for your Makefile with Python][2].

Here is a summary of the important bits to remember when working with Makefiles.

[1]: https://tech.davis-hansson.com/p/make/
[2]: https://blog.mathieu-leplatre.info/tips-for-your-makefile-with-python.html

## Why use `make`

### Age and Network Effect

[`make`] has been around for 50 years.
With time, comes de facto status, inertia, and [network effects].
It's been used by many projects, in many places, by many people.
Its syntax may be arcane to beginner's but this is the same argument for why most shell scripts are written for `bash`.
I don't see very many people argue for using a non-bash shell for their scripts 😒.

It's not for lack of trying.
If I had a dollar for every time I've had the displeasure of working on a homegrown replacement, I'd have enough to
fund my donut addiction for the rest of the year.
People need to reign in their Not-Invented-Here syndrome.
Unless you're Big Tech, your paltry replacement stands little chance at convincing more than captive audience at your company.
See [Earthly] as an example of a well-thought through tool, not a hacked together bash script.

[earthly]: https://earthly.dev/
[network effects]: https://en.wikipedia.org/wiki/Network_effect
[`make`]: https://en.wikipedia.org/wiki/Make_(software)

### Dependency Management

It's unlikely that your homegrown bash/python script has fully thought through dependency management.
Without dependency management, your script is likely written [imperatively], instead of declaratively.
If you don't understand why it's preferable to write a developer tool [declaratively], maybe you shouldn't be in the
business of writing developer tools.

Declarative programming means your dev tool script tries to get to a desired state.
We want to set up a dev environment to a known state, this makes it easier to support and extend.
For example, "I declare that the dev environment use Python 3.9" sets up the environment so that you can simply assume
`python` means Python 3.9.
Contrast this with `sudo apt-get install python3.9`:

- former may noop, latter always runs
- former guarantees `python -V` is 3.9 while the latter simply installs python 3, it may keep `python` as 2.7

[imperatively]: https://en.wikipedia.org/wiki/Imperative_programming
[declaratively]: https://en.wikipedia.org/wiki/Declarative_programming

### Customization and Extension

By using a de facto tool, everyone benefits because we all understand the rules.
We can add new recipes or debug existing ones.
We can extend, without learning a new framework.

We shouldn't have to debug your trash bash scripts.
Rolling your own tool discourages customization.
I'd probably do the sensible thing and just escape hatch out of your tool, just use it as a wrapper.

## Fundamentals

### Everything is a File

[In Unix, "Everything is a file"][3].
`make` follows the same paradigm.

[3]: https://en.wikipedia.org/wiki/Everything_is_a_file

_Recipes/Targets_ are used to build files.
They are used in dependencies.
Sometimes we don't have concrete files but we should use sentinel files to achieve this.

For example, the first thing when setting up a Python dev environment is to create a virtualenv.
This produces a folder.
To make this play nicely with `make`, use a sentinel file instead:

<!-- markdownlint-disable no-hard-tabs -->

```makefile
venv/venv.touch: requirements.txt
	python -m venv venv
	venv/bin/pip install -r requirements.txt
	touch venv/venv.touch

.PHONY: test
test: venv/venv.touch
	venv/bin/pytest
```

<!-- markdownlint-enable no-hard-tabs -->

The `test` recipe requires a Python venv as a dependency.
Concretely, it depends on the abstract notion of "Python environment with dependencies installed".
We've captured that abstract notion with a sentinel file.
We'll see why this is useful in the next section.

### File Modification Time

`make` uses file modification time in its dependency heuristic.
If the output file's timestamp is more recent than the dependency, this means nothing has changed since the recipe was
last run.
We can noop, saving time.

In the normal use case, this makes a lot of sense.
To produce `output.o` object file, we depend on `object.c` source code.
Only when the source code has been modified (newer timestamp than object file), will the artifact become stale.

How does this work with sentinel files?
Using a sentinel file gives us more fine-grained control over "last modification time" control.
In the example above, the `test` recipe depends on a python venv, which in turn depends on `requirements.txt`:
if `requirements.txt` is newer than `venv.touch`, this means dependencies were changed and venv needs to be rebuilt.
You can see why we used a sentinel file instead of the `venv` directory directly:
directories are only modified when files are added or removed, blind to when containing files themselves are modified.

### Dependency Tree

When writing recipes, understand that you will form a dependency tree.
You need to avoid forming cycles.
The best way to keep this sane is to ensure that every upstream dependency is a file.
And ensure that reruns are idempotent.
Idempotency is key to declarative programming, this is no different.

`make` is smart enough to prune the tree, thanks to its use of file modification time.
There's no additional heuristic, the framework is set up to behave like this.

## Tips

These are tips to avoid pitfalls.
`make` is old as time, so many of these gotchas are warts that were probably formed before your parents were even born.

### `make` Version

Macos still ships with `make` version from 1989.
I didn't look into why because it's bound to make me lose brain cells.

If any of the following tips don't work, check the version of `make`.
Many features for `make` came out in the last 20 years.
Upgrade it.
It's 2022, we shouldn't be supporting software from pre-2015.
That's like choosing to drive a 1992 Civic and bitching that Honda won't backport all the safety developments over the
last 3 decades.

### Tabs

`Makefile` use tabs.
It feels like the last decade has put an end to "spaces vs. tabs" debate entirely, with _Team #spaces_ emerging victorious.

Most editors will set tabs when working on a `Makefile`.
But it's easy mistake to blanket set up "use spaces all the time", which will fail horribly here.

[GNU Make 3.82] (2010) introduced `.RECIPEPREFIX`, which lets you override the tab symbol to something else.
Note to avoid special prefix characters `-` (ignore error) and `@` (no echo).

[gnu make 3.82]: https://lists.gnu.org/archive/html/info-gnu/2010-07/msg00023.html

### Use Sentinel File to Represent Many Files

Always use a single file as a dependency for many files.
This is the same as a surrogate key.
This often means adding a sentinel file, when your recipe produces many files.

For example, creating a dev environment might involve setting up a Python venv and npm.
Represent the "dev environment" dependency with a single sentinel file.
Your recipe for running tests do not need think about whether they need Python installed or Node, or both:
they simply need to know if the dev environment is fully initialized or not.

### `.SHELL`

You can set `make` to use a different shell, when executing commands.
This grants the ability to use shell syntax, such as command substitution.
A lot of gotchas occur here because one assumes that it uses the user's current shell or `bash`.
This is the same gotcha as with many tools that use `/bin/sh` to be POSIX-compatible.

The default shell is `/bin/sh`, which is the default shell for most things (see docker).
`/bin/sh` is an interface for POSIX shells:
`dash` on many debian systems;
`bash` on older macos;
`zsh` on newer macos.

#### `.SHELLFLAGS`

You can also set `.SHELLFLAGS` to set default options.
For `bash`, this is the old-tried-and-true `-eu -o pipefail`.

```makefile
.SHELLFLAGS := -eu -o pipefail -c
```

Note the `-c` is so that the actual command in the recipe is passed in to the shell.

### `.ONESHELL`

By default, each command in a recipe is executed in a subshell.
This makes them isolated from each other.
This is a common gotcha.

Setting this option will make the recipe behave as if it were a big shell script.
You can then set state and do other shell programming things.

A nice side-effect is that avoiding extra subshells will have better performance.

### `--no-builtin-rules`

`make` was built for compiling C projects.
It has defaults set that don't make sense to be defaults today.

```makefile
MAKEFLAGS += --no-builtin-rules
```

This tells `make` not to do any magic, such as automatically mapping C source to objects.

### `.DELETE_ON_ERROR`

`make` is not atomic.
If a recipe fails part-way, it can certainly leave the system in a broken state.
You can force targets to build with `make -B` or by touching dependencies.

`.DELETE_ON_ERROR` will delete the target file if the recipe fails.
This makes things more robust, "rolling back" and cleaning up.
It facilitates rerunning, makes things feel declarative.
