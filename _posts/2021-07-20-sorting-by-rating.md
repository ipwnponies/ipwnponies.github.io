---
title: Sorting By Rating
categories: math
tags:
- algorithm
- statistics
---

I recently read this post about [SteamDB's rating algorithm][1].
SteamDB sorts games by popularity.
This is defined as games that have a lot of total review traffic and a majority of the reviews are positive.

[1]: https://steamdb.info/blog/steamdb-rating/

It doesn't use the specific review score, just qualitatively binning as either positive or negative.
This is akin to *Rotten Tomatoes* scores, which are a percentage of thumbs-up/ thumbs-down.

## Problem With Trivial Sorting by Rating

This [old post from evanmiller][2] discusses why it's nontrivial to sort by rating.
It highlights two failure cases with trivial algorithms:

- `score = (positive ratings) - (negative ratings)` uses absolute difference but does not take into proportional ratio.
  This leads to negative games with more total traffic volume being scored higher.
- `score = (positive ratings) / (negative ratings)` uses ratio, which doesn't take into account total volume.
  This leads to single review games to be scored highly.

[2]: https://www.evanmiller.org/how-not-to-sort-by-average-rating.html

## Elements Needed in Algorithm

We established that we want to put both *total volume* and *positive:negative ratio* into consideration.
To put in words, we are saying to use the *positive:negative ratio* but give more certainty if there are more total reviews.
This can be done by biasing the score, using the total count in an exponential fashion.
Consider the following setup:

> If *game1* has 10 reviews, 8 positive and 2 negative. The score is ~80%.
>
> If *game2* has 100 reviews, 79 positive and 21 negative. The score is 79%.

You can intuit that you probably want to rank the second game higher, even though it objectivelyi has the lower score.
There is less uncertainty and we can consider its score is be more stable.
Another bad review to *game1* will change its score to **73%** (8/11, -7%),
while *game2* will change to **78%** (80/101, -1%).
It's stable because it's closer to the true score and we have higher confidence that additional reviews
 will not significantly change the scoring.

## Formula

So the new formula is really easy to understand:

```ignore
total = positive reviews + negative reviews
raw_score = positive / total
bias = (raw_score - 0.5) * 2^-log(total + 1)
score = raw_score - bias
```

We regress towards the mean.
The more reviews we have, the lower this weighting should be (negative exponent).
This will significantly depress scoring on games with low total review count, which reflects the uncertainty
we have in the score.

As review counts increase, we converge closer to what we believe is the *true score*.

## Old Formula

The previous formula SteamDB used is called the [*Wilson's Score*][3].
I've taken a look at it and it's a doozy.
It requires statistics knowledge and I am not qualified to make any determination on its correct usage.
While it may be mathematically correct or give higher precision, I think the simpler score we've established here
is quick and easy to implement.
And for whatever needs I have to do sorting, it's more than "good enough™".

[3]: https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Wilson_score_interval
