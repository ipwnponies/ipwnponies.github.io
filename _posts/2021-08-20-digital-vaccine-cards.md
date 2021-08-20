---
title: Digital Vaccine Cards
categories: technology
tags:
  - cryptography
---

Cities in America (New York and San Francisco) are beginning to require proof of vaccination to enter certain places,
like gyms, restaurants, and indoor event centres.
Why are they doing this now?

We're at a point where vaccination campaign has "completed".
There's a large pool of the population that can safely gather due to:

- lower personal risk, as vaccines are shown to lower severity of COV-19
- lower transmissibility

This is unlike 2020, where the primary tool was social-distancing and city-wide lockdowns.
As we start to see surges, we now have a new phase to rollback to first, before instituting lockdowns again.

## Why Not Lockdown Again

Are you shitting me?
Did you see what happened in 2020?

Lockdowns in America were barely lockdowns.
More like "being grounded" in your room, which has all your sweet toys.
But you can't have your friend Jerome come over to play.

Enforcement was largely garbage.
Lockdowns are a forfeit of civil liberties (for the benefit of society, in this case).
An authoritative state will always be able to pull this off more effectively.

No matter how you feel about lockdowns, it would eventually be adopted by large urban areas at some point in 2020.
Health systems are not made to handle spikes, they are very inelastic.
See emergency scenarios for working examples of this.

## Vaccinations Changing the Landscape

We're at a point where the majority of American who want to be vaccinated, have done so.
Vaccinations have been shown to lower the risk.
Lockdowns were instituted because we had no other choice.

Now we can restrict those in attendance to be vaccinated.
This preserves the ability for restaurants, gyms, and gatherings to continue, albeit with a subset of the population.

We are now at a position where the lowest common denominator (unvaccinated) is at a small enough percentage and
we do not need to cater to them.
This is no different than when Android or iOS drops support for old ass-phones.
This puts the onus back on the individual: either get vaccinated, if you can, or manage your risk by limiting exposure (immunocompromised).

If there continue to be breakthrough cases and the surge gets worse, we still have the option to lockdown.
But if it's greatly reduced by the proof of vaccination requirement, the majority does not needlessly give up
liberties for the benefit of minority.
Or at least that unsavoury choice can be deferred for longer.

## Vaccine Cards

To provide proof of vaccination, Americans are using the [little vaccine card][1] they received.

[1]: https://en.wikipedia.org/wiki/COVID-19_vaccine_card#United_States

Watching the proof of vaccination requirement slowly come into being has hurt my brain.
It's like watching amateurs fumble as project requirements change but their implementation was hilariously not extensible.

The United States took an early stance to [not require _vaccine passports_][2].
Clearly for political reasons but that's besides the point.
As a result, the CDC has been issuing vaccine record cards when you visit.
This card is clearly for record-keeping, so that you remember when to come back and what vaccine product you got.

[2]: https://en.wikipedia.org/wiki/Immunity_passport#United_States_government

It's literally mass-produced and printed on stock card, then filled in by hand.
Look, you can even find an [empty template scanned on Wikipedia][3], it's not sensitive information.
The fact that [forgeries or thefts][4] have made the news hurts my soul.
The skill level to pull off this forgery can be found when a teenage student forges a sick-note from their parent,
like [Ferris Bueller's][5] phone call.

[3]: https://en.wikipedia.org/wiki/File:COVID-19_Vaccination_Record_Card_CDC_(8-17-2020).pdf
[4]: https://en.wikipedia.org/wiki/COVID-19_vaccine_card#Issues
[5]: https://en.wikipedia.org/wiki/Ferris_Bueller%27s_Day_Off

The original requirement was probably:

> Must record date of vaccination, so you don't forget to come back.
> It's like your dentist appointment, who seriously remembers anything after 6 months.
>
> Must record product, so that you don't forget whether it was Astrazenca or Johnson & Johnson.
> Let's be serious, this was a real risk until somehow getting Pfizer suddenly become a social status.
>
> Maybe have some sort of identifier, just like when your barista asks for your name.
> They don't actually give a shit that you're "Bond. James Bond", they just need some rudimentary contact information
> to call you back in case they fucked up.
>
> Out of scope: use of this for anything serious, such as confidentiality and integrity.
> Seriously, America's going to figure some shit out of with vaccine passports, so let's not invest too much here,
> it's "only a stopgap™".

And now everyone wants some sort of record for proof and this forgettable business card is supposed to be as
bullet-proof as how we mint paper bills.

## Digital Vaccine Cards

Digital vaccine cards to the rescue.
State governments have started to issue digital vaccine cards.
To unfuck this situation we're in.
Hooray.

And what struck me as strange is suddenly the masses are cryptography and privacy experts.

> I don't want to give them my health records

The fuck? They already have this.

> What if I'm hacked?

Uh... so that a hacker can use your vaccine card?
Like we have an anti-vaxxer who is skilled enough to pull this off and their number one priority is maintaining their
vaccination agenda, not making millions of black-hatting?

> How do we know this works? It's untested technology.

What the fuck?
It's literally existed since the 70's.
You use it everyday, when give up all your privacy to social media and location sharing.

> I don't understand this/I'm going to wait for experts.

I'm a goddamn expert (relative to you).
It's like when you decided you know more than a doctor because you self-diagnose yourself on WebMD.
You lack the skills and knowledge to understand this, yet you cannot bring yourself to trust anyone who does.
So I guess I'll see you in 5 years, and meet you on the other side of a Computer Science program.

### What Data is Needed

What does a vaccine card need?

It needs to have identifying information.
In an ideal world, the issuer would include your public key.

It needs to state your vaccination record.
The level of detail, I don't know.
But it's reasonably insensitive information, such as how long ago.

That's it.
Surprising, right?

When you pay with your credit card at the store, the card is the only piece of information they need.
It provides the financial information of who to charge to.
And a name, for courtesy reasons.
The card itself is built with anti-forgery mechanisms, such as the chip.
This is basically a digital signature, embedded in the chip, that tells the machine a third piece of information: am I authentic?

### Integrity

How do we prevent forgery?
Digital signatures!
These are used by your browser all the time, to ensure you're connecting to correct website and not a forged one.

Digitally signing a vaccine card produces a hash on the data above.
This is signed by the Public Health authority's private key.
And can validated against the public key.

### QR Codes

These vaccine apps are using [QR codes][6].
A QR code is just a visual representation of binary data.
This is how businesses can easily scan and verify the data.
These apps can pull the public key and ensure message integrity.
From there, they can trust the data provided is authentic.

[6]: https://en.wikipedia.org/wiki/QR_code

### Authentication

I talked about how we'd authenticate using a public key, to verify the user.
Unfortunately this is no-go, as not everyone has a keys.

Practically speaking, we'd stop here and simply provide the business with the name tied to the QR code.
It is up to the business to verify identity, such as driver's license.
Or another system, with a QR code and all.

### Expiration

Another issue is that we would want these codes to expire and allow rotations.
2FA changes the code every minute, which limits the window that an attacker can reuse a code.

Why bother doing this? Once you're vaccinated it doesn't change.

Because not everyone has an app or mobile phone.
A QR code can be printed, faxed, or emailed.
When discarded, an attacker can pick this out of the trash and reuse it.

This is as simple as adding an `expiry_time` to the payload.
When refreshing a QR token, the default for a mobile app might be 30 seconds.
When printing it out, maybe 1 day.

I'll be honest, I don't know if this is something that will be implemented.
It seems like something that's good for further enhancing the business side of things.
While the business still has to manually verify ID, at least we increase the burden on forgers.

i.e. If your friend needed to pass the test, you could send your QR code to them.
Your friend just needs to get a fake driver's license.
But I've now made it more annoying because the QR code is only good for 30 seconds.

If you request a token for longer, then we can have paper trails.
And the token generated can have additional message, telling business to scrutinize closely for ID theft.
