---
title: Debounce In JavaScript
categories: programming
tags:
- javascript
- performance
---

Debouncing is a technique for buffering user interaction: multiple inputs are reduced and deduplicated.

## Etymology

The term *debounce* comes from switches in electronics.
The mechanical contacts of a switch will bounce when they make contact, due to momentum.
This produces a jittery signal.
Different filters are used to remove this signal bounce, to produce a cleaner, square wave signal.

## JavaScript

In Javascript, we see [use of debounce][1] to buffer user input.
A user might hit the submit button twice or triple-click.
Another common use is background network calls, such as fetching data for a search query:
each additional letter to the query can result in a new request for data.

[1]: https://www.freecodecamp.org/news/javascript-debounce-example/

Without debouncing, many requests can be needlessly sent to server, inducing unnecessary load.

### Roll up Multiple Actions

The first use case is if you want to delay performing an action, in case there's additional invocations or modifications.

For a search query, this can be the suggestions based on the partial query.
Only the results for latest partial query is desired, the rest are useless work.
By delaying invocation, we can absorb more of the changes before we begin to take action.

Another example is saving changes.
We will want to wait for the user to idle before we persists the ongoing progress.

```js
function debounce(func, timeout = 300){
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => { func.apply(this, args); }, timeout);
  };
}
function saveInput(){
  console.log('Saving data');
}
const processChange = debounce(() => saveInput());
```

This code creates a timer to perform the action.
If the user continues to take action, we'll renew the timer by deleting the previous timer and creating a new one.

### Swallowing Redundant Actions

The other way is to first perform the action and swallow any follow-up duplicate calls.

You would use this to ignore duplicate calls: double click, retrying an action, refreshing a status,

```javascript
function debounce_leading(func, timeout = 300){
  let timer;
  return (...args) => {
    if (!timer) {
      func.apply(this, args);
    }
    clearTimeout(timer);
    timer = setTimeout(() => {
      timer = undefined;
    }, timeout);
  };
}
```

In this version, the action is taken immediately and a boolean flag is set (presence of timer).
Until the timer fires, subsequent triggers will be ignored and noop.
Once the timer is reached, the boolean flag is unset and the action can be taken again.
