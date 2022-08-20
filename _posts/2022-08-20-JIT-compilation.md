---
title: Just-In-Time Compilation
categories: programming
tags:
  -
  - compiler
---

[Just-in-time compilation][wiki] is realtime, dynamic compilation.
It's recently become a popular way to execute code.
By diving into how it works and the concepts involved, hopefully we can understand how it's differentiated from
standard compilation or interpretation.

[wiki]: https://en.wikipedia.org/wiki/Just-in-time_compilation

## Machine code

Let's get deep for second.
To run code, we need hardware, namely the CPU.
The CPU works in the real, analog world and uses signals from voltages.

Voltage gets quantized at the high/low threshold, turning it into binary signals.
What binary signals do we give?
Why, it's our program!

The format that the CPU is designed around is called [machine code][machine-code].
The format are a series of OP codes and the input to the instructions.

[machine-code]: https://en.wikipedia.org/wiki/Machine_code

At the end of the day, our programs must produce executables that provide binary instructions to the CPU.
These instructions are codes for adding, branching, jumping, register loading, etc.

## Static compilation

Binary is not very human-friendly format to write code in.
Assembly is human-readable and it's essentially syntactic sugar that maps 1:1 with binary.

As we write assembly in text, we compile it down to binary executable.

Extend this concept to higher-level languages:
our C program must compile and produce machine instructions.

A compiler is the tool that does this transformation.

### Static Compilation - Benefits

When we compile, we target different architectures.
This allows use of complex instruction sets if available.
Using native instructions will grant performance improvements.

For example, some microprocessors have instructions to handle cryptographic functions.
This might take a few CPU cycles to complete.
Trying to implement this in software involves cobbling together add, multiply, register load, and other instructions.
Making use of this will greatly speed up the program.

### Static Compilation - Downsides

Because we need to target different instruction sets, a single program may have 5-10 different target platforms.
Every time we make another change, we need to compile for all these target binaries again.

Supporting a wide range of instruction sets is a lot of maintenance.
Nowadays, it's typically to see x86, x86_64/amd64, and ARM.
5 years ago, ARM might not be as common.
And even 10 years back, amd64 too.

## Interpretation

We can also have interpreters.
These are binary programs that accept source code input.
Rather than compile the source code to its own executable, the interpreter is the program that executes based on the
source code contents.

When it sees `1 + 1`, the interpreter will:

1. Tokenize by whitespace.
1. Transform into [Abstract Syntax Tree][ast].
1. Make machine instruction calls for `add` when it sees `+`.

[ast]: https://en.wikipedia.org/wiki/Abstract_syntax_tree

### Interpretation - Benefits

There's only one executable here, the interpreter.
By passing in a source code to interpret, we can get a different program to run.
We've avoided the need to compile a new set of executables!

The python folks will be responsible for compiling an interpreter for different platforms and maintaining it.

You can take your source code and drop it on any machine and trust the interpret to do the right thing.
If the machine has cryptographic function support in the CPU, the interpreter will automatically know to make use of that.
Otherwise it will have an internal implementation.
What a nice abstraction.

### Interpretation - Downsides

As you can see from the steps, there's overhead in interpreting the input.
With static compilation, we were able to translate it to instruction codes ahead of time.
But now we must do this mapping in realtime.

## What is JIT

Now that we're familiar with static compilers and interpreters and their pros and cons, we can begin to understand JIT compilers.
JIT compilation is a hybrid approach of _Ahead-of-Time_ compilation (AOT) and dynamic interpretation.

It's a runtime that will interpret the source code.
As it runs, it decides that some of the commonly-used code should be compiled to native code, allowing it to skip
interpretation overhead in future calls.

> JIT compilation combines the speed of compiled code with the flexibility of interpretation.

### Startup Performance

The startup time of JIT runtime will be slow.
The code will initially be dynamically interpreted.
As the runtime notices hot paths, it will compile them.

This causes startup time cost, which is amortized over time.

### Portability

JIT compilation feels dynamic because it is.
You drop the exact same code on any platform and it's the runtime that will JIT it to the corresponding architecture.

There is no downside compared to an interpreter.
There really aren't many true, pure interpreters.
The overhead of dynamic interpretation is typically infeasible.

### Future-proof

As technology changes and improves, the JIT runtime will be updated.
The source code is unchanged, yet it could experience performance improvements.

Statically compiled code will never change, for a give CPU.
It's deterministic for life.
You would need to recompile the code and generate a new binary, to make use of any new feature.

### Memory efficient

Only hot paths will be JIT.
The code paths will be interpreted in memory.
This can result in a smaller running footprint than a compiled program, where 100% of the program will be loaded into memory.

## TLDR

JIT compilers are really an evolution on how we run code.
In many applications, it strikes a nice balance of performance and maintenance burden.
I'd say that for the majority of software development, you can expect JIT compilation to be overwhelmingly preferred.

For niche, purpose-built applications (networking) or constrained environments (embedded), static compilation will be necessary.
But given the niche or targeted purpose, the downsides are not as big of a deal.
