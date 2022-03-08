---
title: Use Line_profiler Without Magic
categories: programming
tags:
- python
- profiling
- debug
---

I found this excellent blog post, from Lothiraldan, on [how to unmagickify `line_profiler`][1].

[1]: https://lothiraldan.github.io/2018-02-18-python-line-profiler-without-magic/

Adding a `@profile` decorator is all that's needed, if you invoke the python code through `kernprof`.
`kernprof` injects the necessary dependencies.

But I've always felt it was icky because it severely restricts the supported and documented use cases.
How do I profile `flask`?
Or `pudb`?

As it turns out, it's just requires a little bit of boilerplate to replicate `kernprof`.

```python
import line_profiler
profile = line_profiler.LineProfiler()

import atexit
atexit.register(profile.print_stats)
```

That's literally all I use `kernprof`  for:

- it magically imports `@profile` decorator but I can just mundanely import a decorator.
- it registers a "finally" to print the profiling output. Not rocket science.

Voila!
Now it's the long game of waiting for another situation to arise, for which this is the exact magic bullet.
Insert reference to [XKCD].

[XKCD]: https://xkcd.com/208/
