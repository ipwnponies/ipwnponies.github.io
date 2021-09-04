---
title: Air Quality Index
categories: science
tags:
  - pollution
  - indices
---

I learned about the Air Quality Index today.
You will too.
Let's go.

## Wildfires in California

[Wildfire season][1] is a fact of life for California residents.
It typically occurs around June to September.
Large swaths of forests burn each year and the State continually employs firefighters to fight the wildfires.

This is driven by the climate of the coast, which is dry and warm year round.
This causes drought conditions and vegetation will dry up, turning it into potential biofuel for the fires.
It seems like California is basically [always in a drought period][2].

These conditions make it easy for many things to be the source of ignition:

- lightning
- campfire
- downed power lines
- parents who felt the compulsion to share the type of genitalia their gestating offspring has, to all of California.
  A text would have worked too, fyi

[1]: https://en.wikipedia.org/wiki/List_of_California_wildfires
[2]: https://en.wikipedia.org/wiki/Droughts_in_California

As such, many folks are well-versed in looking up _air quality index_ alongside the daily weather report.

## Air Pollution

There are many sources and types of air pollution.
The levels are very regional and impact to health is very individual.
We're going to focus on the pollutants that have an effect on air quality and human health.
There exists some "pollutants" that have very little human health effect, such as carbon dioxide.
Climate change is a separate discussion altogether.

Measuring pollutants involves both time and concentration components.
High concentrations can be dangerous, even if exposure is limited.
Low levels but for prolonged periods can be just as debilitating.

### How It Changes

Air pollution can increase due to increased emissions, such as during rush hour traffic or as a result of wildfire.

Air pollution can increase due to stagnant air, caused by low wind speeds or temperature inversions.
Temperature inversions are a weather phenomena that traps the air of a local region.
This can be visually seen with fog, where it hangs low to the ground and doesn't get blown away.

### Types

Ozone at the ground-level irritates the respiratory system.
Ozone is reactive and we don't like reactive molecules in our body: that's where free radicals and oxidation comes into play.
Prolonged exposure can damage lungs permanently.

Particulate matter (PM) are small particles that are suspended in the air.
These are things like:

- pollen and spores
- bacteria
- dust
- smoke and soot

Particles that are larger than 10 microns will be filtered out via cilia and mucus.
Smaller particles are able to make it pass our systems.
In particular, smaller than 2.5 microns can penetrate even deeper.

Abestos is an example of a particulate matter, at 1 micron.
And its mechanisms for health detriment is making it to your lungs and cutting shit up.

Carbon monoxide is another pollutant and is produced by incomplete combustion.
In a local level, we know that suffocation can occur with high enough levels.
This is because carbon monoxide will bind to blood cells as it it were oxygen.

Sulfur dioxide is mildly toxic and long-term exposure has lasting health effects.
It contributes to acid rain.

Nitrogen dioxide is as by-product of combustion.
It is also a respiratory irritant.
It contributes to acid rain.

### Concentration Measurement

Each of these pollutants are measured on different scales and units.
I'm not sure why but it's probably a holdover from old industries.

Ozone, sulfur dioxide, and nitrogen dioxide are measured in parts per billion (ppb).
Carbon monoxide is measured in parts per million (ppm).
And particulate matter is measured in μg/m3.

Observe that all 3 are density measurements.
It makes sense that particulate matter is measured by mass: it's not composed of the same molecule.
There can be more or less individual parts per volume.
It is strange that carbon monoxide isn't measured in ppb, that one is likely a holdover from industry common practice.

### Time Measurement

There is a time component to the air quality measurements as well.
Sustained measurements are the ones of interest.
Instantaneous increases in pollutants can quickly dispersed and be of little health consequences.

## Air Quality Index

There doesn't seem to be a common standard for measuring air quality.
I'll be discussing both the Canadian Air Quality Health Index as well as the American Air Quality Index.

### AQHI

This [system was created in 2005][3] and is now the standard across Canada.
It measures ozone, nitrogen dioxide, and PM2.5.
It looks back 3 hours.

[3]: https://en.wikipedia.org/wiki/Air_Quality_Health_Index_(Canada)#Calculation

The formula is a exponentially weighted sum of the pollutant measurement.

### AQHI - Categories

The output of this formula is a score from 1-10, with values greater than 10 bucketed in the same category.
There are 4 categories, that roughly correspond to risk levels.

- 1-3 is low risk
- 4-6 is moderate risk
- 7-10 is high risk
- 10+ is very high risk

At-risk population should begin considering reducing outdoor activities when it reaches moderate risk levels.

General population should begin considering reducing outdoor activities when it reaches high risk.

### AQI

The [Air Quality Index][4] is a _piecewise linear function_.
Each interval corresponds to a risk category.
Within an interval, the index is a linear function based on the level of pollutants.

[4]: https://en.wikipedia.org/wiki/Air_quality_index#Computing_the_AQI

The index attempts to produce a unitless index that allows comparison among the pollutants.

### Index Intervals

The index intervals are split into 50 wide segments: 0-50, 51-100, 101-151, etc.

This means each category is evenly spaced.
It's up to choosing what pollutant measurements map to each interval's bounds.
The wider the measurement range, the

The ranges tend to increase as the index increases.
This makes it exponentially increasing, albeit without a single continuous function.
This allows precision fine-tuning to map a pollutant's dose-response to match the sentiment of the risk category.

### AQI - Categories

The categories are:

- 0-50 is good
- 51-100 is moderate
- 101-150 is unhealthy for sensitive groups
- 151-200 is unhealthy
- 201-251 is very unhealthy
- 300+ is hazardous

As you can see, there is a little more granularity here, compared to AQHI.

### Different Pollutants

Different [types of pollutants](#types) vary in potency, as well as dose-response relationship.
For each pollutant, each category has been assigned a range of measurement values.
For example, PM2.5 is assigned 0.0-12.0 μg/m3 for an index of 0-50.
The interval grouping is arbitrary and is meant to convey relative risk, without trying to force out a single
continuous function.

Ozone is two times, with 1 hour and 8 hour time windows.

### Calculating the Index

To calculate an index is pretty straight-forward.
For a given value, you're trying to determine which interval it falls into and what proportion of the interval that is.
The index represents that proportional value.
i.e. If PM2.5 is measured to be 9.0, this is 75% of the _good_ interval.
The index range is 0-50, which gives this a final AQI of 38 (75% of 0-50).

The reported AQI index is the maximum of the AQI of each pollutant.
This differs from AQHI, which incorporates all the pollutants.

## Cigarette Equivalence

[Someone did a study][5] to quantify what the equivalent of air quality to cigarette smoking would be.
They came up with smoking 1 cigarette per day as equivalent to PM2.5 of 22 μg/m3.

[5]: https://berkeleyearth.org/air-pollution-and-cigarette-equivalence/

A cigarette is equal to an AQI of 72.
And 2 cigarettes daily is equal to an AQI of 122.

If you live in a highly polluted region, you're involuntarily "smoking" cigarettes against your will!
What a not-so-fun fact!
