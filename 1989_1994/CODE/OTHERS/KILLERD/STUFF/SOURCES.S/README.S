This contains information to supplement that in the manual.

This is DevpacST Version 2.00

New Features in Editor
=====================
Not a new feature at all really, we've just never documented it before.
To search and/or replace Tab characters press Ctrl-I in the dialog box.
They will be echoed as clock face characters.

When using Run Other to run a program you may pass the name of the file
you are currently editing by including a % in the command line, which
will be expanded. A true % may be specified using %%

New Features in Assembler
=========================
The default for option M, macro expansions, is OPT M-.

The directive OPT U+ changes local labels start with underlines (_) instead
of periods, to allow code to be generated for the Prospero range of
languages.

In the .TTP version the tab size used when listing may be specified using
the option -Txx, for example -T10.

New Features in Debugger
========================
The command Ctrl-E forces all exceptions to be re-installed. This can be
useful when dealing with compiled programs whose run-times use the
exceptions themselves.

If you enter AMONST2 during the boot sequence you may abort its
installation by quitting with Ctrl-R instead of Ctrl-C.

Please note decimal numbers are now denoted with \, not # as in version 1.

The Binary File Load command (page 103) does not yet support an explicit
load address.

New Feature in Linker
=====================
An additional directive is allowed in control files:
TRUNCATE
This truncates all symbols to 8 characters, sometimes required to link
assembly language with long labels to compiled code with short labels.

Lattice C Users
===============
Now supplied is a replacement C.LNK file for use with Lattice C 3.04.
Using it with LINKST will reduce your link times and also reduce your
output file size by using a true BSS-type section.
If you use the -n option of the compiler (page 132) you will be able
to specify HiSoft Extended Debug when linking, allowing longer and more
meaningful symbols when debugging with MonST2.
