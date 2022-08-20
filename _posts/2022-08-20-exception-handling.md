---
title: Exception Handling
categories: programming
tags:
  - computer science
  - code style
---

> Never use exceptions.
> Always use an if-check to avoid errors.

Ever hear someone spout this.
I have and I'm tired of hearing this nonsense being repeated without critical thought.

## TLDR

Use exceptions.

Use if-checks.

Don't try to replace the screwdriver in your toolkit with a hammer.

## Why Avoid Exceptions

The only reason for avoiding exception handling is performance.
To understand why exceptions are slower, we need to understand what's being done at the machine-instruction level.

### If-Check

An if-check is a a Branch or Jump instruction.
This is effectively a GOTO at machine level.

As it's a single instruction, it can be performed very quickly.
It mutates the _Program Counter_ (PC).

### Exception Handling

When an exception is encountered, an exception instance is created.
This involves collecting the stacktrace.

Then the exception is raised.
This is a more complicated GOTO.
It involves unrolling the stack frame incrementally until we reach a level where a handler is found.

After executing the handler, we release the exception and do clean up.

As you can see, this is lot more involved than a if-check.

### Performance

Performance depends on the language implementation.
In Java, C#, and C++, exceptions can be 10 times slower.
In Python, the difference is reduced, maybe 2 times slower.

The difference is explained by the overhead of other code:
updating references, local variables, etc.

## Why it's an Invalid Statement

If exception handling is so slow, why am I telling you to use them?

Because we haven't talked about **when** we are going to use them.
Just what happens afterwards.

> You should only use exceptions when it's exceptional behaviour.

Why, in the ever-loving fuck, would you use an exception for control flow?

```python
class Dog(Animal):
  def say():
    raise DogException('german shepherd')

def animal_say(animal):
  try:
    animal.say()
  except DogException as e:
    print(f'woof, i am a {e.message}')
```

This code makes no sense, it should obviously use if-statements.

### Exceptional Circumstances Require Exception Handling

Use exceptions when the error is unexpected or very infrequent.
For example:

- out of memory. We typically don't expect every memory allocation to fail.
- invariants being violated. Assertions
- missing config values. Configurations are set up by us so they should always exist.

### Non-exceptional circumstances should use normal control flow

Use if-checks for normal program control flow.
For example:

- user login. User authorization is always tenuous.
- data validation
- user input

### Why performance doesn't matter

If we only use exceptions when it's exceptional, then the cost is amortized.
We only get performance penalty when we encounter exception.
And when that happens, we have exceptional handling behaviour to help recover.

With if-checks, your code will be littered and have runtime performance costs.

```python
# No handling. Fastest
memory.allocate(1000)

# Try-catch. If no exception, is equivalent to previous. Else slowest
try:
  memory.allocate(1000)
except:
  print('OOM')

# If-check. Constant cost of checking
if os.free_memory > 1000:
  memory.allocate(1000)
```

This example illustrates why if-checking is slower, if you never encounter exceptions.
And you never encounter exceptions... because they're exceptional.

## Conclusion

Please stop parroting bad advice you heard on the internet.

Please stop applying advice you learned for Java but when you code in Python.
Go back to Java then.

Please stop abusing exception handling for control flow.

Just use exceptions as they're designed.
And use if-checks as they intended.

Also performance doesn't matter.
If it did, you wouldn't need me to tell you about when to use exceptions or not.
If your exception was frequent enough to impact performance... you already goofed.
