---
title: How To Extend Wifi Range
categories: technology
tags:
  - networking
---

In a home network setup, there is typically only one modem or access to the internet service provider.
From here, access is shared amongst clients in the home through a router.
The router assigns addresses and routing logic, so incoming internet traffic can be routed to the correct client.

A wired network will involve Ethernet cables, which need to physically connect the client to the router.
A wireless network will involve Wifi, which will wireless connect clients to the access point.
In a large space, it becomes difficult for clients to connect:

- wiring ethernet may involve drilling holes to route cabling
- wifi signal degrades over distance and with obstructions in the path

The problem is that it's not trivial to extend the range, as if you were extending a power cord or a water hose.
Every client needs to connect the main network, which is centrally located.

## Extending Wired Connections

For wired connections, the answer is always more wiring.
As long as you can get an ethernet cable to the client, you're golden.

Ethernet has a maximum range of 100 meters.
Beyond that, you need an repeater, which is a dumb device that boosts and retransmits the same signal.

If you need a hub, a network switch is a dumb device that will multicast the ethernet packets to all connected clients.
Effectively, you'll have a flat topology, where all clients are directly connected to the main router.

## Extending Wireless Connections

There are 3 ways to extend the range:

- wifi extender/repeater
- wireless access point
- wireless mesh

### Wifi Extender

And extender works much like a network switch.
It rebroadcasts all the wifi packets, at a distance away.
This allows clients positioned further away to communicated with the extender, which will repeat it to the access point.

The upside is that this is a dumb device is inexpensive.
It only needs to be connected to power.

The downside is that this device rebroadcasts on the same medium.
If you're in between the access point and the extender, you'll see all traffic duplicated.
The increased wireless traffic results in more noise and lower speeds.
If you set up a third extender too near, you could even reduce bandwidth to 1/3, as all traffic is tripled!

There's no reason to use this setup.
If all the wireless clients are too far away, move the access point closer.
Or set up a closer access point, and connect it to the first with an ethernet cable.

### Wireless Access Point

A wireless access point (WAP) is connecting access points together through ethernet.
The access points configure the SSID and password to be the same, allowing clients to connect to either.
Each WAP is connected to the original as a LAN client.
They disable any DNS or DHCP settings, deferring that to the original access point.

They are set up as nodes for providing last mile service over wifi.
The internal network is ethernet, all connected to the same router.

The upside to this is that the bandwidth is not halved.
Because the WAPs use separate mediums for communicating with clients vs. router, there is duplication of wireless packets.
If you put the WAPs too close, there will be a loss in bandwidth due to wireless contention.
Theoretically you could put the WAP great distances away, such as from your house to the shed in the back.
They're simply connected by ethernet.

You can repurpose used routers to handle this as well.
This can make it cheap, as it only requires leg work for installation and no new hardware.
Otherwise routers can be had for as little as $20.

The downside is that this necessarily needs to be connected physically.
Often times, you set up a wireless network in the first place because wiring was already an issue.

Note that it's important all the secondary access points do not setup DHCP, DNS, SSID, or other settings.
They exist only to communicate with clients over Wifi and relay this to router over ethernet.
The main router should handle everything, and this keeps the network topology shallow and easier to manage.

#### Sticky Clients

An issue with using multiple WAPs is a sticky client.
This is a Wifi client who hangs on to the original WAP, as long as the signal is above a certain threshold.
It doesn't switch to the closer WAP.

This is entirely dictated by the client firmware/software.
Some android devices allow you to set the Received Signal Strength Indicator (RSSI) threshold and you can make it more
aggressive, which will disconnect the client if it falls below that level.
Once disconnected, the client will attempt to connect to the next candidate, which will likely be the closest WAP.

There are some controls that can be done on the network side.
A WAP, with sufficient software capabilities, can disconnect a client with RSSI threshold.
This will send a disconnection packet to the client (Wifi protocol) and trigger it to reconnect.

The sticky client problem is largely a problem with roaming.
Phones are liable to experience this, as they move from room to room.

### Wireless Mesh

This is a newer technology that has been getting popularized over the last 5 years.
These work like extenders except they are smart.
Each node communicates to each other and they route traffic over Wifi.
This is basically akin to a network router, whereas wireless extenders are akin to network switches.

The upside is that these are easy to extend and self-manage.
If a node is offline, the remaining nodes will propagate this information and traffic will reroute.

If you need more range, you add another hop with a node.
The new node will register itself into the network and the client's data will magically route itself to the origin.

The downside is cost.
The mesh nodes communicate to each other through a protocol.
You have to buy wireless mesh devices, they are a distinct and new hardware.
It can cost $200-300 to initially get set up.
