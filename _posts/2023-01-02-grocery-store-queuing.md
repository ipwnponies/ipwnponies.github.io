---
title: Grocery Store Queuing
categories: thinking
tags:
  - algorithms
  - computer science
---

When you go to the grocery store, there's always the dreaded checkout lines to contend with.

## Computer Science

- in computer science, this is studied with scheduling theory
- real-time systems have to work on minimizing latency, which means longer tasks get pre-empted
- non-realtime systems can handle jobs in FIFO

## Conventional Queuing Setup

In a conventional American supermarket, the checkout queuing setup is multiple queues.
Customers will line up behind each register.
In this setup, it's on the customer to select the optimal lane, as their goal is to complete checkout as quickly as possible.

Unfortunately, there are too many random factors involved to make good decisions:

- how fast an individual cashier is (processing speed)
- how many items a customer has (volume of work)
- how fast a customer is (interactive input)
- special circumstances that cannot be predicted: price check, customer ordering item that is locked up
- cashier changes or lanes opening/closing

As a customer, you're really making an educated guess but there is large variability that it often minimizes the
actual control you are exerting.

### Advantages to Conventional Setup

This setup typically has shorter lines and less customer movements.
For example, With 10 lanes open and 20 customers, you will expect 1 customer queued up behind each lane.
The customers wait statically for a longer period, which increases effectiveness of the impulse purchases that are
stationed at the checkout.
You can also leverage these hotspots for advertising or other messaging.

The other advantage is that it gives customers a sense of control.
They "choose" the lanes and feel rewarded.
If it's slow, they might be willing to scapegoat themselves for making the wrong choice.
Americans love having a sense of control and freedom of choice, it's also a cultural thing.

### Why Is This Still Used

One thing to keep in mind is that many grocery stores were setup in the 60's or 70's and they are still in use today.
There is inertia to switching systems, such as getting your customers onboard without attrition.
The supermarket industry is large volume and low margins, so it makes sense why they are very often conservative when
it comes to change.

Many stores were designed with the store layout to be multiple lanes.
It's no longer appropriate to switch systems as that would require updating the layout.
Keep in this in mind, you may notice that newer stores and/or supermarket chains are the ones that have the
opportunity to establish a different convention.

### Express Lane and Self-Checkout

It's a huge problem when you have one item to purchase but need to queue up behind a people doing their monthly grocery shop.
This is a problem of latency.
One thing that conventional supermarkets have done is added express checkouts or self-checkout lanes.

This is basically a 2-lane system, where each queue has constraints for the task that can enter the queue.
Depending on the distribution of tasks, the system can quickly degraded again, if you don't have enough express
checkout lanes open.

With self-checkout, it's often common to employ the Single-Lane queue (more on this later on).

## Single-Lane Queue

There's a 2007 [nytimes] article that discusses the approach used for Whole Foods in New York.
Because of the smaller real estate, it made more sense to set the store up with a single-lane setup.
Every customer queues up in the same lane and the head of the queue gets serviced by the next available cashier.

[nytimes]: https://www.nytimes.com/2007/06/23/business/23checkout.html

### Not Exactly Pioneering

Let's step back and think about this a bit: is this actually a novel concept?
You'll quickly see that it's really only supermarkets that use multiple queues approach, they're the oddballs.
Here's a short list of examples of single-queues systems:

- bank tellers
- admission to zoos
- airport check-in
- fast food

Pretty much anywhere you can have multiple cashiers, it's natural and organic evolution to start from a single lane:

1. Open the store with one cashier because there are no customers yet.
2. Customers begin to queue up for the only open till.
3. When things start to get busy, a new checkout till is opened.
   Since there's already a line, you just help the next available guest.
4. When things die down, you close down the number of tills.

This is exactly how distributed computing works, there's usually a common queue, serviced by multiple workers.
The workers scale elastically, according to demand.

### Practical Applications

In practice, a single-lane queue will eventually require a "line manager".
This role serves to coordinate and herd customers, to keep the line moving.
If customers are left to their own devices, it allows a single baddie at the head of queue
(cell-phone-ringing hot-mess guy) to hold up all the workers.
This scales `O(N)`, which is bad.

### Advantages to Single-Lane Queue

Because you corral all customers through a common path, you don't need as much real estate for duplicate
advertisements or impulse purchase items.
However, the queue does end up moving quickly, which can result in less time exposure.
And since you're corralling them through a common path, it can be psychologically harder to "abandon", since you might
have to leave the way you came in.
Think of how much work it is to leave the line at a Disneyland ride.
Although this is probably considered a dark pattern.

A single-lane setup is easier for the customers.
It removes their choice.
While it's nice to score a quick checkout, it can really suck if you end up behind a slow one.
Reducing this variance makes the checkout more predictable.

### Performance

A single-lane queue will have no difference in performance compared to a multiple-lane queue.
It's easier to convert this to queue-worker tasks.
Assuming all the workers are equivalent, the time taken to process the queue is the time taken to process all the tasks.
That will never change.

What does change is _wait time_ and fairness.
Different algorithms exist in the realm of [scheduling algorithms][wiki].
We'd want to pick something that optimizes for minimizing _wait time_.
But we want it to be _fair_.

[wiki]: https://en.wikipedia.org/wiki/Scheduling_(computing)#Scheduling_disciplines

#### Wait Time

Wait time refers to how long a task/customer has to wait in the queue.
Customer grow more impatient the longer they wait, with the perceived waiting time being magnified.

If you have more items to checkout, you will likely tolerate a longer periods.
If you are only purchasing one item, it feels bad to have to wait 5 minutes, the same time as someone who needs to
purchase 100 items.
This psychological factor means that the priority of a customer must be somewhat correlated to the "size of their job".

Customers will tolerate a bit of latency and other techniques can be used to distract them:
moving along in a line incrementally will give a sense of progress, compared to standing still for long periods at a time;
TVs or other entertainment can distract customers for a bit.

Single-lane minimizes the variability of picking a "bad lane".
There is no "bad lane", if a customer has many items or is a baddie, they only hold up a single cashier.
The rest of the cashiers continue to be free to process customers.
Since the baddie will take up time in either setup, the throughput is unchanged but the worst case _wait time_ is minimized.

#### Fairness

Fairness is simple: nobody gets to cut the line.
If there are two carts, one is full and the other is 50%, no one would suggest that the half-full cart gets higher priority.

But then what about express lanes?
This is really multiple queue, where some queues have constraints.
For practicality, this tends ot the be the extent of splitting queues, as people tend to not be good at following more
than a few rules.

In a single-lane queue, fairness is basically the core design principle.
If you enter the queue first, you get served first.
You get access to the shared pool of cashiers, any of whom can process the head of the queue.

This should minimize the average wait time overall.
