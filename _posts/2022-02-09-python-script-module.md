---
title: Running A Python Script Vs. A Module
categories: programming
tags:
  - python
  -
---

If you have a python file named `src/main.py` and want to run it, it's pretty straight forward:

```py
python src/main.py
```

But you can also run this with:

```py
python -m src.main
```

They'll both work the same.
Or do they?

This post was instigated by reading through [this stackoverflow post on relative vs. absolute imports][1].

[1]: https://stackoverflow.com/questions/14132789/relative-imports-for-the-billionth-time

## Script or Package

We need to first define what a script is and what a package is.

A script is a standalone file, containing executable code.
A package is an ecosystem, where modules are composed together.

The differences end mostly at the conceptual ideal.
In practice, the differences are much more nuance and this is where a lot of the confusion comes at, the implementation details.

### `__package__`

When you run a script, there is not `__package__`.

When you run a module, there is a package that the module belongs to.
This alows you to detect whether the current python process was invoked upon a script or a module.

### `__name__`

`__name__` is the variable for the name of the current module.

When you run a script, the name is `__main__`.
This is what allows the `if __name__ == '__main__':` snippet to function.
Other files you import will retain their import name (i.e. `import foo` will have the name of `foo`)

When you run a module, the name is dotted notation.
`python -m src.main` will have `__name__` of `src.main` in `src/main.py`.

For imports, the name is simply the fully qualified import name.

```py
import foo  # foo.py will have __name__ of foo
from bar import baz # bar/baz.py will have the __name__ bar.baz
```

## Relative vs. Absolute Imports

Imports can be absolute or relative.
Absolute imports are anchored to the package root, while relative imports are anchored to the current file.

In my opinion, absolute imports are the clearest way to handle imports.
Deep nesting might be a sign that your package is too complex and should be decomposed to more packages.

Relative imports have the merit that they allow entire subdirectories to be moved without rewriting the imports.
This is a mild inconvenience though, as tooling is capable of rewriting imports automatically.

Relative imports are denoted by the use of a leading dot:

```py
from . import bar # bar is a sibling module

from ...package import module # ../../package/module.py
```

## `sys.path`

When the interpreter encounters an `import` statement, it searches through the locations in `sys.path` for a matching module.
This is how stdlib is automatically available to all scripts.

Understanding how `sys.path` works is **fundamental** to understanding the difference between running a script or a module:

- when invoking a script, it's containing directory is added to `sys.path`
- when invoking a module, the root directory (current dir) is added to `sys.path`

```sh
python src/main.py # src/ will be added to sys.path
# `import src.foo` will look for src/src/foo.py

python -m src.main # pwd will be added to sys.path
# `import src.foo` will look for src/foo/__init__.py
```

Do you see the difference?
This makes it fundamentally impossible to execute a script as a module, unless the script is located in the root directory.

I'll repeat this again:

> A python script can be executed as a module IFF it is located in the root directory.

If your script is elsewhere, you're going to need to fudge with imports or `sys.path`.

## Never run a python script again

If you have a script and it's far too much hassle to fully qualify it with `python -m`, there are still solutions.
Using `setuptools` or `poetry`, you can setup _script entrypoints_.
When installing the local package, these build systems will create the shims to conveniently invoke the scripts.

I discovered this the hard way, when trying to get [`typer`] to work correctly.
`typer` works by importing the script, because `typer` itself is what the python process was originally invoking.

[`typer`]: https://typer.tiangolo.com/
