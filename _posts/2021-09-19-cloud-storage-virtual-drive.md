---
title: Document Backup In The Cloud
categories: technology
tags:
  - cloud
  - disks
  - computer science
---

Cloud storage has been around forever.
With more devices than ever, cloud storage is a convenient way to share and synchronize data.
It's also very easy as a backup solution for important files, as opposed to rolling your own.

## Google Drive and Their Clients

I've used Google Drive as a simple synchronization setup.
The service is fine and I've never had issues.
The desktop clients are a mess, with differing compatibility and clients for different OSes.
There's been like 3 clients within the last 4 years.

I'm being [forced to switch to a another client again][1].
This might be excusable, as it's a consolidation between their enterprise and consumer clients.
Why they have 2 solutions for solving the same problem is a mystery to us all.
I would hope that the Google Drive backend is the same service for enterprise and consumer.

[1]: https://www.androidpolice.com/2021/02/04/googles-terrible-drive-desktop-client-will-soon-be-replaced-by-g-suite-version/

The two clients are _Backup and Sync_ (consumer) and _Google Drive for Desktop_ (enterprise).
The [differences][2] between two are minor.
Notably, it's possible to sync individual files.

[2]: https://support.google.com/drive/answer/7638428?hl=en

This got me thinking about the pros and cons of this approach.

## Cloud Storage Synchronization

### Basically managed `rsync`

_Backup and Sync_ was a simple tool: it effectively `rsync` the target directory.
When you add a new device, it will initially download the entire contents of the directory.

The benefit of this is the simplicity and the [_Principle of Least Surprise_][3].
There's no gimmick, these are all are real and normal files.
100% guaranteed compatibility with any and everything.

[3]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment

The downside is the initialization cost when setting up on a new system.
Like `rsync`, the first time requires a full sync.
This also uses up disk space.

### Lazy Loaded

Many cloud storage solutions use lazy-load solution: the files are fetched upon first access.
This reduces unnecessary network load onto them, while also benefitting the client similarly.

_Google Drive for Desktop_ refers to this as "streaming".
It probably makes more sense to the layman, akin to "on-demand".
To a tech person, this is misleading: it's not streaming, like a streaming a large file or whatever.

The manifest is provided that provides information on what files exist and the metadata.
When a specific file is requested, a fetch is made for the contents and cached.
This is good because commonly used files will behave like regular files, with low latency.

You can make files as "available offline" if you need it to work independent of network connectivity.
This results in downloading the file.
In event of a network disruption, you will have fully cached the file beforehand.
Change made during this time will be queued up for synchronization later on.

Files you have previously accessed are available offline.
However, understand that it's subject to cache eviction at any time and it would suck if that's when you lose network connectivity.
Please mark them as offline, even if they already available through the cache, to signal the proper intent.

## Virtual Drive

I wasn't curious enough to look up how these systems work.
But I imagine it's as straightforward as intercepting syscalls for files.

The manifest is downloaded and shows which files are available, locations, and metadata.
The data itself is not, which is where the network and storage savings are.
When opening a file for reading, the sys call is intercepted and this is where either data is retrieved from the cache
or remotely fetched.
If there is no network connectivity, this step can block or timeout.

This seems like implementing a "virtual drive".
