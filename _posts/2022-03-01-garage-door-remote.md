---
title: Garage Door Remote Control
categories: technology
tags:
- security
---

Garage door remote controls have an [interesting history][1] in their evolution.
They used to be simple radio transmitters, which worked fine when few people had them:
now their ubiquity necessitates digital security.

[1]: https://en.wikipedia.org/wiki/Garage_door_opener#Remote_control

## First Generation - Fixed Frequency

The first generation consisted of a simple transmitter and receiver.
The transmitter was tuned to a designated frequency.

It was not uncommon to trigger the remote for a neighbour's garage.

## Second Generation - DIP Switches

The next generation sent digital codes.
The code was keyed in via 8-12 DIP switches.
This provided 2**12 combinations, 4096.
You would key a unique combination and hopefully this would not contend with a neighbour.

The goal of this iteration was to avoid interference.
It did not address security.
4096 is not a large number of codes, it's possible to design devices that transmit all the codes in a short time.
Or an attacker could attempt a replay attack, where they would record all the codes sent when the homeowner left the house.

## Third Generation - Rolling Codes

Modern garage door remotes now use rolling codes.
The transmitter learns from the receiver, where the transmitter's identifier is sent and a seed is shared amongst the two.
Every time you transmit, the next code is generated.
This is akin to a psuedo-random number generator.

Since the codes are rolling, you cannot reuse past codes, making it impervious to replay attacks.

Because the transmitter may be used when out-of-range, it may waste codes.
The receiver must be tolerant of this loss and be prepared to lookahead in the rolling codes.
If the transmitter gets too far ahead, for practical reasons the two systems will desynchronize.
At that point, it will need to be reprogrammed.
