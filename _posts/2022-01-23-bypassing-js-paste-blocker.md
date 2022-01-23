---
title: Bypassing JS Paste Blocker
categories: programming
tags:
  - javascript
  - web
---

Many sites use JavaScript event handlers to prevent copy or paste actions.
The idea is that they can prevent you from copying text, which is borderline idiotic if you know anything about how
the web works: the source is available because it's necessary to display it in the first place.

Other sites prevent pasting, this is usually some misinformed notion of security.
I'm not sure why you think it's more dangerous for me to paste a password from a password manager.
And if you're aware that you're discouraging the use of complex passwords, in favour of simpler and shorter to enter ones.

Well, since the browser is a client that I'm in control of, I'm not having any of this shit.

## DontFuckWithPaste

I found this [browser extension][1] that hijacks copy/cut/paste and noops them.
Basically use the same trick right back at them.

[1]: https://github.com/jswanner/DontFuckWithPaste/blob/master/content.js

The key part is to have high priority and then prevent event bubbling:

```js
document.addEventListener(
  "paste",
  (e) => {
    e.stopImmediatePropagation();
  },
  true
);
```

You can target the element that is problematic, as a way to bypass and allow you to enter the text field.
