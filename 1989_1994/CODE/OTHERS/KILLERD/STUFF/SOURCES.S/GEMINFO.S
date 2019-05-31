
	About GEMDEMO
	=============

The file GEMDEMO.S contains the source code to a simple GEM application
which creates a window that can be moved and sized. An oval shape is
drawn in the window to fit exactly the window size. When the Full box is
clicked an alert box is produced, and when Close is clicked the
application quits.

The code uses the GEMINC.S file to get the necessary macros and constants
to call GEM. The purpose of supplying the GEMDEMO file is to show the
method by which assembly language programs call GEM AES and VDI.

It is not possible for us to supply enough technical information for
you to program extensively under GEM - for this you will have to use
the DR manuals, or the First Publishing/Abacus books.

What we are supplying is the assembly language interface to GEM, which
is currently not detailed very well in any document.

The DR documentation refers to the C programming language, so I shall
try to give the details to convert it to 68000.

There are really three levels of operating system on the ST:

Firstly there is the BDOS and BIOS, which makes up GEMDOS (also known
as TOS). They are called with Traps #1, #13 and #14. They are like
CP/M, with low level calls for disc access, character I/O, etc.

Next there is GEM VDI, which is a device-independent way of accessing
graphics functions, such as filling, drawing lines etc.

Finally there is GEM AES, which handles the user-interface, windows,
menus, dialog boxes etc.

When you write a GEM program you will generally have to access all
three levels of the operating system.

	GEMDOS (TOS)
	============
This requires the other include file, GEMDOS.S for its constants
and macros. The calling sequence for the BDOS is to put a variable
number of parameters on the stack, then a word for the function
number, then do a Trap #1. You should always correct the stack afterwards
Calling the BIOS is similar, but using Traps #13 and #14, and results
are returned in registers.

	GEM VDI
	=======
This requires an array of five long words, each pointing to other
arrays of various sizes. The main array is called VDIPAR in the
include file, and the other arrays are called by their official
names of contrl, intin, ptsin, intout, and ptsout. To access
the various elements in the arrays, you have to add twice the element
number (as each element is a word). So, the C line
	intin[1]=2;
converts to the assembly language
	move.w #2,intin+2(a6)

I access 'global' variables off A6, simply because I always have
done. You can of course use absolute locations for your globals,
but the A6 method does save an awful lot of code (2 bytes per MOVE).
All the code I write is position-independent, again out of habit.
The VDI calling sequence is pretty horiffic. This is probably
because of the 8086 origins, which is a processor with very few
registers compared to the 68000. To call the VDI, you have to set up
the required elements of the arrays (except contrl[0]), then use
the macro 'vdi' followed by the function name, e.g.
	vdi vs_clip

	GEM AES
	=======
The AES also requires a major array, called params, which is 6 long
words, each of which points to other arrays, called control, global,
int_in, int_out, addr_in, and addr_out. These names are rather similar
to the VDI names, and a common error is to mistype them as the VDI names.
There is a subroutine in the GEMINC file that sets up all the elements
in the control array, so to call a GEM function you use the macro
'gem' followed by the function name, e.g.
	gem form_do
It returns with d0.w containing int_out[0], which is usually useful.

	Registers
	=========
No existing documentation says what registers get corrupted by any
ST O/S calls. I assume that d0-d3/a0-a3 get corrupted, and preserve
those that are required. They certainly do not corrupt any others,
as DevpacST wouldn't work if they did, but they may corrupt a lesser
number - better safe than sorry.


The best way of getting familiar with any operating system is to try
it out, and you can start by changing the GEMDEMO application. Once
you've changed it, I'm afraid we can't help you if your modified
version doesn't run properly. If you do have problems, you can use MONST
to debug it.

Good luck!


Andrew Pennell

Last changed: 2nd June 1986
