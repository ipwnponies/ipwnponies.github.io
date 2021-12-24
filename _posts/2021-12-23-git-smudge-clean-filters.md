---
title: Git Smudge And Clean Filters
categories: programming
tags:
  - git
  -
---

[Git-lfs][1] is a great solution to managing large binary files in git.
It makes clever use of git filter capability to operate.

[1]: https://github.com/git-lfs/git-lfs/wiki

## Why Bother With Git-Lfs

Git is a version source control that targets code.
Its internals are highly optimized around this and it works stupendously well.
However, people still feel compelled to shove binary blobs into it.

### How Git Handles Binary Blobs

Git stores only the diffs for files, within commits.
This makes it very compact and powers many features such as _annotations_ (_blame_).
Binary data is not as structured as text and small changes in the source can produce large changes in the binary output:

- recompiling code will regenerate new symbols and jump tables
- editing text will change the compression heuristics, as frequency tables are retabulated
- changing a colour in a section of an image may change multiple layers

When done naively, binary files will produce large diffs in git and these are stored away.
Every small change has an outsized effect and the repository size quickly grows.
The size of the workspace will remain the same, it's the git objects that exist for git history.
Imagine a 1 MB file that is updated daily, this can use up 300 MB within a year.

### Why Are Large Files An Issue

Any git operation that references the binary file will require git to reproduce the file.
With normal text files, git just reverse applies all the diffs in reverse-chronological order.
With a large file, git is applying many massive diffs.

The final file is used for `grep` or `diff` or `log` operations.

Beyond the disk space usage (storage is cheap), there are reaosns we don't want git to have to deal with this:

- it's a waste of processing resources on git operations because we will usually not care much about these large files.
  We'll need to start filtering by file globs or directories, which is inconvenient but necessary.
- we stored the binary files for historical record, this "compression" behaviour is not desirable nor useful.
  We might as well store the files whole, this makes retrieval only a disk space concern and not processing.

Enter git-lfs.

### How git-lfs works

Git-lfs hooks into the git filter capability and transforms large files upon check-in.
It replaces the blob with a URI and sends the blob to an external store, such as AWS S3.
Upon checkout, it will recognize the URI and fetch from the external store.
The net effect is that git only sees these files as small files with URI for content.
This is much more manageable for git operations.

## git filters

git filters are specified in `.gitattributes`.
A filter is a program that transforms an input file.
They operate at the workspace-repository boundary.
Details can be found in `git help attributes`.

You can specify a "clean" or "smudge" filter.
These are complementary, operating in opposite directions.

Filters are designed to work as tools of convenience.
From the docs:

> [...] the key phrase here is "more convenient" and not "turning something unusable into usable".
>
> [...] if someone unsets the filter driver definition, or does not have the appropriate filter program, the project
> should still be usable.

This makes them poor candidates for scrubbing secrets, as a misconfigured or failing filter will not block checkin.
The smudge operation should be a convenience, the user should still be able to manually smudge if needed.

See this [article][2] for more details on use cases.

[2]: https://www.juandebravo.com/2017/12/02/git-filter-smudge-and-clean/

### Clean Filter

The clean filter transforms files as they are checked into the repository.

```noformat
workspace -> repo
```

As the name implies, this is used to "sanitize" the input.

### Smudge Filter

The smudge filter transforms files as they are checkout out and into the workspace.

```noformat
repo -> workspace
```

Smudge filters can be used to transform things like configs into local versions.
Common tasks can include injecting environment variables or take platform-specific actions.
