# Compile an ultra-simple language to Python, run the program
- define grammar for ABC language
- compile (actually transpile) the language to an Intermediate Language
- compile the IR to valid Python code
- run the Python code
- transpilation happens in several stages
  1. parse
  2. rewrite
  3. run the resulting transpiled code using the host language (Python)

# Usage
`$ make`

The output should be:
```
./pbp/t2t.bash . ./pbp  abcir.ohm abc2py.rwr empty.js test.abcir >test.mpy
node indenter.mjs <test.mpy >test.py
python3 test.py
2
3
5
```

## What does that ouptut mean?
The source file is `test.abc`. 3 lines of code, to keep things simple.
```
b <- 2
c <- 3
a <- b + c
@pr (b)
@pr (c)
@pr (a)
```
The .abc code creates three variables, a, b and c, then prints their values, one at a time.

`b` and `c` are defined as constant numbers (2 and 5 respectively), `a` is the sum of `b` and `c` (5).

The language is too simple to be useful, but, this example shows how to use `t2t` to transpile a new language into Python, then run the code. Instead of build a full-blown compiler for `abc` we build a simple transpiler and let the Python compiler do the heavy lifting.

The example shows how to use `t2t` to transpile a new syntax. 

The example shows how to transpile the new syntax into an intermediate form, then to transpile the intermediate form in pseud-Python. The pseudo-Python code contains brace brackets and is not indentation-based like Python. This makes it a bit easier to use existing compiler tools. We insert special Unicode characters `⤷` and `⤶` to denote indent and exdent. These special characters are used, as a last step, by `indenter.js` to indent the pseudo-Python code and to make it into legally-indented Python code.

# Previous Example
This example extends the previous example `abc` by emitting runnable Python code. The previous example emits legal-looking Python code, but the code is not runnable (on purpose, to keep things simple). Here, we add a `def` statement and a top-level call (to `test ()`) to the code rewriter `abc2py.rwr` to make the code runnable.

# Relationship to PBP (0D)
This project does not explicitly use PBP, but it does use Parts that input from stdin and output to stdout. That is a first step in using PBP - make parts completely isolated, by passing simple string-based messages into and out of Parts. This is very UNIX-y in flavour - one input and one output. Full-blown PBP supports more inputs and outputs, but, we stick to one input and one output for simplicity.

This project uses the `t2t` tool. The tool was originally written in a PBP-based DPL (Diagrammatic Programming Language). When the design of t2t evolved, I migrated the code into pure textual form, and converted the code to Javascript. This two-stage workflow is quicker and more flexible than the standard one-stage workflow wherein one writes all of the code in Javascript right off the bat. Debugging and incrementally improving a design in diagram form is easier than debugging and incrementally improving sequential code. It actually saved time to write the code twice - the first time in a DPL, the second time in Javascript. Most modern programming languages emphasize optimization and sequential, clockwork behaviour. It is safe to say that EVERY project begins with undertainty about what's actually needed. Maybe, in the future, we will be able to compile diagrams into final, optimized code, but, we're not there yet. We can compile diagrams into code which is not as optimal as hand-tuned code. This is the way that compilers were developed; In the 1960s, compilers emitted code that was noticably worse than that which expert assembler programmers could produce, but, that evolved over time and now, compilers can write better code than that produced by assembler programmers (assuming that you can find any assembler programmers anymore).
