---
title: Stable Marriage Problem
categories: math
tags:
  - algorithms
---

## Stable Marriage Problem

The [_stable marriage problem_][wiki] is a matching problem between two equally sized groups.
Each element of a group has an ordering of preferences for elements of the other group.
A solution would match pairs optimally, maximizing preference.

[wiki]: https://en.wikipedia.org/wiki/Stable_marriage_problem

## Matching library

The [`matching`][pypi] library can solve these solutions.

It also contains a [concise explanation][2] of the problem.

[2]: https://matching.readthedocs.io/en/latest/discussion/stable_marriage/index.html
[pypi]: https://matching.readthedocs.io/en/latest/

## Stability

The difficulty in finding a solution is achieving _stability_.
A participant would want to change their pairing, if a higher preference is available.
By switching, this frees up their former partner, which triggers another set of evaluations (instability).
Convergence on stability means that all participants can not find another for whom they would both be better matched together.
In this sense, stability is when we arrive at a "deadlock".

## Variation

### Stable Roommate Problem

The _stable roommate problem_ is a matching problem but there is only one pool.
It's the idea that a big group splits into smaller groups of roommates.

Another example would be when kids find a partner for a school project.

### Hospitals/Residents Problem

The _hospitals/residents problem_ is a variation of the _stable marriage problem_ but there is a 1:N matching.
Each hospital has several open positions and each resident wants to work in one of these positions.

This is the ranking system they used at my university for matching co-op students to companies that were participating
in the program.
It was incorrectly referenced as _stack ranking_, which has a [whole other meaning][stack-ranking].

[stack-ranking]: https://en.wikipedia.org/wiki/Vitality_curve
