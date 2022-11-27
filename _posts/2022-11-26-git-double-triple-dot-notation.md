---
title: Git Triple And Double Dot Notation
categories: programming
tags:
  - git
  -
---

Many git commands accept either a single revision or a range.
For example, `git log` or `git show`.
This is similar to a file glob but for git commits.

Most of these commands accept a variadic number of cli args to facilitate this.
Because using a contiguous range of revisions is a common operation, there exists the _Dotted Range Notation_.
This can either be double-dot or triple-dot notation.

The [docs for git revisions][1] has the full documentation.
I find these types of concepts hard to discover within the official documentation.

[1]: https://git-scm.com/docs/gitrevisions#_dotted_range_notations

## Double-Dot

The double-dot notation is equivalent to `^r1 r2`.
In set terminology, this is a set difference of `r2 - r1`, which show the commits unique to `r2`.

In written words, this asks for the the commits reachable from `r2` but excluding those reachable from `r1`.

This range is used very often.
It's purpose is to get the list of commits that are unique to `r2` and this is typically a feature branch compared
against the upstream base branch.
Github's pull request commit list uses exactly this.

## Triple-Dot

The triple-dot notation is equivalent to `r1 r2 --not (git merge-base r1 r2)`.
In set terminology, this is the symmetric difference, the commits that are unique to either ref.

In written words, this is everything that is not common to both refs.

This range is useful when you want to compare two feature branches and suss out upcoming merge conflicts.
You're interested in the commits added to both branches since the common ancestor.
You can imagine this is useful for `git diff`, which scopes down the commits to scan and thus the amount of files that
could have changes between the branches.

## Git Diff

`git diff` behaves entirely opposite to `git log` when it comes to handling of double/triple-dot notation.
Note that it is [`git diff` that has customized behaviour][2].

[2]: https://git-scm.com/docs/git-diff#Documentation/git-diff.txt-emgitdiffemltoptionsgtltcommitgtltcommitgt--ltpathgt82308203-1

> However, "diff" is about comparing two endpoints, not ranges, and the range notations (\<commit>..\<commit> and
> \<commit>...\<commit>) do not mean a range as defined in the "SPECIFYING RANGES" section in gitrevision.

When given multiple refs, `git diff` is comparing two "endpoints", not revision ranges.
While this makes sense why, it's the unfortunate overloaded usage that causes boundless confusion on the internet.
These are the two stackoverflow posts I continually refer to, because they serve as better working documentation than
the official docs:

- <https://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif>
- <https://stackoverflow.com/questions/462974/what-are-the-differences-between-double-dot-and-triple-dot-in-git-com>

### Git Diff Double-Dot

When using a double-dot for `diff`, this is equivalent to `git diff r1 r2`.
This is asking for a diff between these two refs, which is the typical use case.

### Git Diff Triple-Dot

When using triple-dot for `diff`, this is equivalent to `git diff r1 (git merge-base r2)`.
The use case is to get a diff of the changes that have been introduced in `r1` that `r2` does not have.
This is useful for to see the changes added in a feature branch, while ignoring the newer changes in upstream branch,
such as for a pull request.

This is what Github pull request uses for the diff view.

### Recommendation

As you can see, `git diff` doesn't really benefit from the expressiveness of the dotted notation.
With the unfortunately chosen opposite meaning, I would recommend not using dotted notation at all for diffs.

- if you want to diff A against B, use `git diff A B`
- if you want to diff A against common ancestor with B, use `git diff A (git merge-base A B)`
