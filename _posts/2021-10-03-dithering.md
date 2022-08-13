---
title: Dithering
categories: gaming
tags:
  - algorithms
  - images
  - game dev
---

[Dithering][1] is image processing technique, that aims to reduce colour banding.

[1]: https://en.wikipedia.org/wiki/Dither

It's applied with a dotted or checkerboard pattern of alternating colours.
The result, when blended, produces a blend of these colours.
Blue and green, in even amounts, would produce yellow.

Blending can happen due to distance, which reduces the eye's resolution.
It can also be introduced due to analog signals or bilinear filters.

## Explanation

It took me a while to grok dithering.
The easiest way to understand is to look at a black and white image.
You will see shades of grey.
If you look very closely, it may actually be a spray, not actual grey pixels.

Dithering is an optical illusion.
The eyes will blend adjacent pixels.
By manipulating the distribution and ratio of pixels, you can produce a new colour that is a blend.
Such as black and white, being used to represent darker or lighter grey.

## Why Bother

Each pixel of an image requires a set number of bits to represent.
More bits will allow more colours to represented but require more data.
The entire screen's worth of data will be blitted to the screen.
Large resolutions will have many pixels.
These two concept together result in the GPU VRAM requirements.

Reducing the bit depth will decrease the memory requirements linearly.
Using dithering, especially at high-resolution, can be effective way to fake higher bit depth.
Think of black and white, 1 bit depth: dithering allows for mimicking greyscale, this is what many printers do.

If you had excess computing resources, don't use dithering.
Increase your bit depth and represent the accurate colour.

## LCD Screens

Note that this concept is nearly identical to how LCD displays work.
Each pixel has 3 LED diodes: red, green, and blue.
They are spaced close together and the human eye blends the output wavelengths together.
A uniform distribution of blue and green wavelengths produces yellow.

If we look very closely at the screen, we can discern the separate diodes and their colours.
At normal viewing distances, however, it blurs into a new colour altogether.

Like before, if you can have LED diodes that produced more colours, use those.
Blending red, blue, and green is good enough, as we have made pixels small enough.
