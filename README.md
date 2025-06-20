# Compile an ultra-simple language to Python, run the program
- define grammar for ABC language
- compile (actually transpile) the language to an Intermediate Language
- compile the IR to valid Python code
- run the Python code
- transpilation happens in several stages
  1. parse code written in the new language (ABC in this case)
  2. rewrite the code into some already-existing language (I chose Python, YMMV).
  3. run the resulting transpiled code using the host language (Python)

This is a follow-on to the `abc` project. In this example, I show how to build and run ABC code using Python as a target language.

# Usage
## install
`$ make install`
## run
`$ make`

## Output
The output should be:
```
$ make
./pbp/t2t.bash . ./pbp  abc.ohm abc2py.rwr empty.js test.abc >test.meta-py
node indenter.mjs <test.meta-py >test.py
python3 test.py
2
3
5
./pbp/t2t.bash . ./pbp  abcir.ohm abcir2py.rwr empty.js test.abcir >testir.meta-py
node indenter.mjs <testir.meta-py >testir.py
python3 testir.py
2
3
5
```

### What does that ouptut mean?
The source file is `test.abc`. This file contains only 6 lines of code, to keep things simple for this example.
```
b <- 2
c <- 3
a <- b + c
@pr (b)
@pr (c)
@pr (a)
```
The .abc code creates three variables, a, b and c, then prints their values, one at a time.

`b` and `c` are defined as constant numbers (2 and 3 respectively), `a` is the sum of `b` and `c` (5).

The language is too simple to be useful, but, this example shows how to use `t2t` to transpile a new language into Python, then run the code. Instead of building a full-blown compiler for `abc` we build a simple transpiler and let the Python compiler do the heavy lifting.

The example shows how to use `t2t` to transpile a new syntax to running code. 

The first example shows how to transpile the new syntax directly into some target language (I use Python, YMMV). The first step of transpilation is to rewrite `test.abc` into meta-Python. The meta-Python code contains brace brackets and is not indentation-based like Python. This makes it a bit easier to use existing compiler tools (like OhmJS, PEG, YACC, REGEX, etc). We insert special Unicode characters `⤷` and `⤶` to denote indent and exdent. These special characters are used, as a last step, by `indenter.js` to indent the pseudo-Python code and to make it into legally-indented Python code.

[aside: Python's indented syntax is meant for human-readability. Existing tools, though, like OhmJS, PEG, YACC, REGEX, etc., expect bracketed code. Python's indentation just makes it harder to parse the code with those existing tools (not impossible, just harder)].

The second example shows how to transpile the new syntax into an intermediate form - `test.abcir`. Then to rewrite this into meta-Python, etc., as in the first example.

# Previous Example
This example extends the previous example `abc` by emitting runnable Python code. The previous example emits legal-looking Python code, but the code is not runnable (on purpose, to keep things simple). Here, we add a `def` statement and a top-level call (to `test ()`) to the code rewriter `abc2py.rwr` to make the code runnable.

# Relationship to PBP (0D)
This project does not explicitly use PBP, but it does use Parts that input from stdin and output to stdout. That is a first step in using PBP - make parts completely isolated, by passing simple string-based event-messages ("mevents") into and out of Parts. This is very UNIX-y in flavour - one input and one output. Full-blown PBP supports more inputs and outputs, but, we stick to one input and one output, here, for simplicity.

This project uses the `t2t` tool. The tool was originally written in a PBP-based DPL (Diagrammatic Programming Language). When the design of t2t evolved, I migrated the code into pure textual form, and converted the code to Javascript. This two-stage workflow is quicker and more flexible than the standard one-stage workflow wherein one writes all of the code in Javascript right off the bat. Debugging and incrementally improving a design in diagram form is easier than debugging and incrementally improving sequential code. It saved time to write the code twice - the first time in a DPL, the second time in Javascript. Most modern programming languages emphasize optimization and sequential, clockwork behaviour. It is safe to say that EVERY project begins with undertainty about what's actually needed. Maybe, in the future, we will be able to compile diagrams into final, optimized code, but, we're not there yet. We can compile diagrams into code which is not as optimal as hand-tuned code. This is the way that compilers were developed. In the 1960s, compilers emitted code that was noticably worse than that which expert assembler programmers could produce, but, that evolved over time and now, compilers can write better code than that produced by assembler programmers (assuming that you can find any assembler programmers anymore).

The use of PBP (0D) in DPL form is shown in other example projects, e.g. the `arith` project.

# Files
A set of source files needs to be supplied by the programmer.

This example shows two ways of generating code
	1. straight from the grammar
	2. generating an IR (Intermediate Representation) from the grammar, then generating code from the IR

Strictly speaking, you only need to use one way of generating code. I show two ways, to give you more choice.

I often generate code straight from the grammar,,, but, I like to find simple ways to generate code and all of my examples tend to be small. IF I were building something quite large, I would choose to use an IR with a more regular, normalized, machine-readable syntax. I favour a Lisp-y IR syntax, because it is easy to parse, it is normalized (there are only 2 kinds of things, functions and basic atoms, and, all code is in prefix form (no pesky infix to parse)) and because there are several choices of already-existing code indenters that can help during low-level debugging and bootstrapping (I use emacs, YMMV).

I tend to think that using a Lisp-y IR achieves many of the goals of "projectional editing", but, I haven't experimented much in that direction.

## Manually written, supplied by programmer
- `test.abc` - simple test program written in ABC (6 lines of code)
- `abc.ohm` - grammar for the example ABC language
- `abc2py.rwr` - rewrite rules from ABC to Python
- `abcir.ohm` - grammar for IR
- `abcir.rwr` - IR code generator (used for creating `test.abcir`)
- `abcir2py.rwr` - rewrite rules from IR to Python
- `empty.js` - placeholder for extra support code (no code necessary for this example, hence, empty)

## Scaffolding for this example
- `Makefile` - makefile for this example
- `README.md` - this documentation file
- `indenter.mjs` - convert brace-bracketed meta-python code to legally indented Python code

## Tools
- `pbp/das/` - ignored (Diagrams as Syntax tool)
- `pbp/kernel/decodeoutput.mjs` - ignored (JSON output decoder needed by `abc` and `arith` projects, but not needed here)
- `pbp/kernel/kernel0d.py` - used by `t2t`tool
- `pbp/kernel/repl.py`- used by `kernel0d.py`
- `pbp/main.py` - ignored (template for main.py in DaS projects)
- `pbp/README.md` - readme for tools directory
- `pbp/refresh.bash*` - ignored (tool development helper)
- `pbp/t2t/lib/args.part.js` - utility functions for `t2t`, included in generated code
- `pbp/t2t/lib/front.part.js` - code snippet included in generated code
- `pbp/t2t/lib/middle.part.js` - code snippet included in generated code
- `pbp/t2t/lib/rwr.mjs` - RWR tool - rewriter DSL, used by `t2t.bash`
- `pbp/t2t/lib/tail.part.js` - code snippet included in generated code
- `pbp/t2t.bash*` - text to text code generator ("transpiler" tool)
- `pbp/tas/` - ignored (Text as Syntax tool)
- `pbp/tas.bash*` - ignored

## Generated Files
- `temp.rewrite.mjs` - generated Javascript program derived from `.rwr` files above, part of `t2t` toolchain
- `temp.nanodsl.mjs` - generated Javascript program that implements `t2t` code generator ("transpiler")
- `test.abcir` - generated IR (Intermediate Representation) version of `test.abc`, used for compiling `test.abc` with to Javascript via `abcirjs.rwr` and to Python via `abcirpy.rwr`.
- `test.meta-py` - generated brace-bracketed Python code straight from `abc.ohm` using `abc2py.rwr`
- `testir.meta-py` - generated brace-bracketed Python code from IR `abcir.ohm` using `abcir2py.rwr`
- `test.py` - generated, runnable Python code straight from grammar
- `testir.py` - generated, runnable Python code from IR

Note that the default option for `make` is to invoke `t2t` twice which will overwrite the first versions of the `temp.*.mjs` files. If you want to look at the generated code for the first versions of `temp.*.mjs` you will need to invoke `make abc2py`.


# See Also
See project [abc](https://github.com/guitarvydas/abc) for something even simpler.

See project [arith](https://github.com/guitarvydas/arith) for a diagrammatic version of a compiler which allows a programmer to build code generators using LEGO®-like black boxes. 

[aside: PBP drawware can be used to build other kinds of things, beyond just code generators, but these examples `abc`, `abc2py`, `arith` show only one use of PBP - that of building code generators].

