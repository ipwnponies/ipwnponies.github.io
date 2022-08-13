---
title: How Bullets Work In FPS
categories: gaming
tags:
  - game dev
  - algorithms
---

I recently watched a [video][1] that explained how bullets work in _First-Person Shooters_.
The two common model are _hitscan_ and _projectile_.
There are compelling trade-offs between different models.

[1]: https://www.youtube.com/watch?v=EpkvNUoxlxM

## Problem

In FPS games, shooting is a core gameplay element.
Design decisions made here can influence and introduce emergent gameplay.

Realism has been an attractive design over the years and physical bullets cannot be model with a simple ray.
Bullets are affected by environmental factors such as wind, gravity, and the medium it is travelling through.
It's well known that snipers need to account for these conditions when adjusting their sights for long distance shots.

On the other hand, modeling each bullet individually in bullet storm games can quickly generate a ton of calculations.
While realistic, this then starts to eat into performance and setting limits on other game elements.

So it's a matter of striking a balance in optimization, which places the game on the desired position between full-on
simulation and ideal physics environment.

## Hitscan

[Hitscan][1] is a simple model, where a bullet is model as a ray.
It travels instantaneously and is unaffected by surrounding elements.
A real-world analogue would be a laser beam.

[1]: https://en.wikipedia.org/wiki/Hitscan

### Hitscan - Advantages

Hitscan is desirable for a game engine as it's very efficient.
Bullets travel instantaneously and are short-lived, able to resolve within a game tick.
A bulletstorm can be handled with little computation overhead.

Calculating where a bullet would go is cheap, as it's linear algebra.
In fact, GPUs area already handle this for lighting effects.

The tradeoff is that there are not bullet effects applied, such as velocity and bullet drop.

### Hitscan - Uses in Games

Hitscan was likely popular in older games as it's simpler to implement and used less hardware.
It was lighter in networking as there are less persisted items to manage.
The bullets probably were a small and compact data structure, as you only needed the trajectory equation.
And each network update was smaller, as every bullet was short-lived and didn't have lingering, outsized effects on
the game world.

Even in modern games, it can see legitimate use.
Many shooters are designed to be played within at close distances, where there are negligible difference in physics.
Opting for hitscan will save CPU cycles and improve game performance.

## Projectile

Projectile model is where each bullet is an instance of a physical game object.
This object would have properties such as current position, velocity, trajectory, and mass.

### Projectiles - Advantages

Projectiles are long-lived and are updated at every game tick.
This could be changes in velocity (air resistance), trajectory (bullet drop), or position (medium).
The instance resolves when it finally comes to a stop by hitting something.

Modeling each instance is requirement if you're going for accuracy in physics.
Like the real world, each bullet is going to do its own thing, at its own pace.

It comes at a huge cost.
Each item adds to the game state and calculations.
Network code is now heavier, as there are more game object updates being sent around.
To ensure game state consistency, there may be latency to ensure synchronization is the same for all clients.
Basically, it's all the cost that comes with long-lived, persistence.

### Projectiles - Uses in Games

This is used in simulation games, to simulate real-world physics.
The [Sniper Elite][2] series is a fun example.
[ARMA][3] is also commonly praised for this.

[2]: https://en.wikipedia.org/wiki/Sniper_Elite
[3]: https://en.wikipedia.org/wiki/ARMA_(series)

While it's subjective how fun realism is, it's clear there's a market.
Setting aside the military simulators, accuracy in physics is often an unspoken but desired trait of a game.
Rockets are expected to either go straight forever or they drop due to gravity or wind.
Anything else is jarring and overly violates our suspension of disbelief.

You can find a lot more single-player games that attempt to implement this.
Our networking technologies are not anywhere near fast enough to handle the massive amount of game updates to ensure
maximal realism.
And it's not even fun multiplayer at that level of accuracy.
I can see, over time, if this stops being a concern.
But hitscan is a very effective, and often necessary, optimization to satisfy modern gaming elements, such as
large-scale battles.

## Hybrid Projectile Hitscan

Some games will employ a hybrid model, using hitscan or projectile on different weapons.
Or at different ranges.

Rockets are projectiles, that take time to cross the map.
Long-range sniper rifle shots are projectile, requiring leading the target and accounting for bullet drop.

In close range, most weapons might become hitscan.
At the close distances, the result is the same but hitscan is simpler and more efficient to employ.

Using hitscan at long-range is inadvisable as it leads to imbalance.
The pistol in Halo 1 is hitscan and was probably not meant to be used for sniping...
But it was used and was very over-powered.
You don't need to lead your shots and bullets are instantaneous.

## Bullet's Origin

The origin of a bullet can be from several different places:

- gun barrel
- player's eyes
- player's chest

There are different motivations for each design choice and each leads to interesting consequences.

### Bullets Originating from Gun

The obvious choice is to have the bullet origin from the gun barrel.
This makes intuitive sense, as it matches reality.
However, it comes with gaming experience complications.

Due to [parallax][4], there's a skew from where you aim and the angle of the bullet.
Humans intuitively know how to account for this because our pair of eyes do this all the time.
If something is closer, we know that the difference in angle will be greater.
At far enough distances, the difference is negligible.
At close distances, it can lead to wonky characteristics.

[4]: https://en.wikipedia.org/wiki/Parallax

A game developer can account for this by adjusting the gun angle, depending on how far something is, like [principal focus][5].
If the target is resolved to be within a close distance, the angle of the gun can be compensated upwards as needed.
If not adjusting automatically, the player will be required to offset from their visual crosshairs, which feel janky.

[5]: https://en.wikipedia.org/wiki/Focus_(optics)

It's also possible to have the gun be obstructed while vision is not, such as peeking over a short fence.
Or to have something directly in front of you but behind the gun barrel.
These issues are manifest in reality but are non-issue:
humans benefit from [proprioception][6], the awareness of the body position in space.
To work around this, game developers can patch these edges cases and give the player feedback cues, such as not being
able to fire or pulling the gun back.
In a sense, the game developers have provided a substitute for proprioception.
Another solution is use of gun sights, which brings the eyes and gun barrel to the same plane.

[6]: https://en.wikipedia.org/wiki/Proprioception

### Bullets Coming From The Eyes

The other common way to model bullets is coming from the eyes.
The motivation is to have this origin at the same place as the camera.
It's literally eye lazers.

The primary benefit is 1:1 mapping to user's perspective: if they can see it, they can shoot it.
The bullet goes wherever you are looking at, no secondary angle or parallax involved.

For multiplayer, there are downsides.
This allows "head glitching", where a player can shoot as long as they can peek over a wall.
For an opposing player, this breaks immersion as bullets seemingly clip though walls.
And the "head glitching" player is taken advantage of the ability to keep the majority of their body behind cover.

Animations typically need to be adjusted to come out of gun, not the middle of the camera/eyes.
This is just for animation purposes, which means we're able to see buggy behaviour such as clipping.
As we've discussed before, these small effects are due to parallax effect and skews only matter at very close ranges.

### Bullets Coming From the Chest

Some games will put the bullets and camera at chest level.
Coupling the camera and bullet origin together maintains the benefits discussed in previous section.
Moving the camera down to the chest removes the ability to "head glitch".

But now you have the other problem, where you can see a player with their head exposed over a wall.
But that player can only see the obstruction.

And the animation is now janky, with bullets coming out of the middle of the screen.
Game developers might use a different animations, which does not match with the bullets being fired.
This moves the bullet away.
