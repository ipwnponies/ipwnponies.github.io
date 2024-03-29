---
title: Backdoor Roth
categories:
  - finances
tags:
  - tax
---

## IRAs

IRAs are retirement investment accounts.
You can contribute and invest, then withdraw upon retirement.
There are pre-tax and post-tax flavours, respectively Traditional IRA and Roth.
Either way, you are paying taxes, so pick your poison.

High-income earners cannot make use of IRA, Traditional or Roth.
There are income limits.

### Traditional IRA

Traditional IRA contributions can be tax deductible or post-tax.
The account is taxed upon withdrawal, in retirement.
This is a tax-deferred account.

The post-tax contributions are not subject to tax.
This is probably done by tracking the percentage of contributions that are pre vs. post tax.
A form must be filed to the IRS every year, to track this information.

I'm not going to think too hard on why this exists and you would want to use it, instead of Roth IRA.
I'll chalk it up to a combination of backwards-compatibility or whining or tax code exceptions.
Tax policies are fun and not at all a paper-filing burden for everyone.

### Roth IRA

Roth IRA contributions are entirely post-tax.
In return, the account grows tax-free.
Distributions, upon retirement, do not count towards income.

You can actually withdraw the nominal amount (principle) from Roth IRA at any time.
Only the earnings are subject to tax and penalty if withdrawn before retirement.

## Backdoor Roth

A backdoor roth is when you **contribute post-tax** to a Traditional IRA, then **convert** it to a Roth IRA.
There is no income limit on post-tax contributions to a traditional IRA.

This is a legal, open secret.
It's not advertised by the IRS but approved.
Tax return tools even handle this situation and fill out the required forms.
It's silly a tax system takes advantage of filers who are not savvy.
Or maybe it's the other way around, the system condones tax avoidance strategies like this.

### Performing Backdoor Roth Conversion

The steps to perform the conversion will depend on the administrator of your IRA.
But the [gist is the same][1]:

[1]: https://thefinancebuff.com/the-backdoor-roth-ira-a-complete-how-to.html

1. Make a post-tax contribution to a **Traditional IRA**.
1. Convert the Traditional IRA to Roth IRA.
1. Report the conversion on tax return.

This [article][fidelity-backdoor] covers how to perform this with Fidelity, which is entirely self-serviced and
straight-forward.

[fidelity-backdoor]: https://web.archive.org/web/20220105233820/https://www.thepainvestor.com/2020/06/15/the-backdoor-roth-tutorial-with-fidelity/

If the IRA has a proportion of pre-tax contributions, then the proportional amount will be transfered.
i.e. If there was already $1000 of pre-tax contributions and $500 is contributed post-tax, then any amount backdoored
will be 66% from the pre-tax contribution.

If you don't have an IRA, then this is actually not complicated as 100% of the contribution will be post-tax.
This may be quite common, if you'ver never contirbuted to an IRA before.
If so, it may be prudent to keep this invariant, to keep the backdoor strategy simple for future years.
This means never leaving post-tax contribution in IRA, which has no benefit on its own anyways (from my understanding).

If you have historically had an IRA but then no longer qualified for IRA pre-tax contribution, then you have to weigh
the cost of all this accounting vs. the benefit of $6000 in a post-tax registered account.

### Tax Filing Backdoor Roth Conversion

This post from the [Finance Buff][2] has step-by-step instructions for report it correctly when filing return.

[2]: https://thefinancebuff.com/how-to-backdoor-roth-freetaxusa.html

1. Enter the traditional IRA post-tax contribution.
1. Enter the distribution, with unknown taxable amount.
   Tax software will estimate a higher tax obligation (income and 10% penalty fee).
1. Enter amount of distribution that was for a Roth IRA conversion.
   Tax software will fill out the necessary forms, which will reduce distribution income.

The reason for all this paperwork is because Traditional IRAs allow both pre and post-tax contributions.
When converting, you resolve tax obligations by paying the prorata tax on earnings.

If you did not have an existing Traditional IRAs, then 100% of the transferred value will be post-tax and these steps
are actually quite trivial.
Otherwise, you need to calculate gains and losses, as well as amount of conversion apportioned to pre-tax.
