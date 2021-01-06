
Some Atari ST code I wrote between 2017 and 2019.

![alt text](st.jpg?raw=true)

I wanted to make a good old demo but it's clear that
I'm not making a lot of progress and I probably won't
finish it. So here's what I had so far.

I released parts of it in 2017 (the dotball) and in
2019 (starfield), but now the source code is available,
along with some extra tests I made along the way.

"2017" is the first thing I tried to re-do, to refresh
my memory about ST coding. I started from my own code
in Blood (the tribute-to-Leonard curve thing) and while
I did improve the code, there's nothing really new here.
I like the colors I came up with. I had a more colorful
version that looked even better in my view at some point
but I cannot find it anymore.

"Fastrot" is a re-implementation of my 1995 article about
'fast' rotations (i.e. without muls). Nothing new either
but I lost my initial code from the ST days so I just
re-implemented the whole thing. It was good practice to
get back in the game. This is the vanilla version that
can rotate anything, it doesn't use symmetries and doesn't
assume anything about the data.

"Dotball" is similar, but IIRC it only works with symmetric
objects (one octant of the object is replicated 8 times).
This also computes the Z to cull away half the dots. This
version is also fairly un-optimized but I had plans for it.

"Record" is a "world record" (or not, but that was the idea),
trying to use all the tricks in the book to increase the
number of dots in the dotball. I still have a kilometer-long
TODO list with ideas & things to try for this one. I released
2 versions already before, this one is a bit faster still.
Unfinished and probably never will, but solid stuff. Inspired
by "The World According to Nordlicht", we had a cool chat
about it on Facebook and that's how it all started.

"Starfld" is a simple starfield but with a twist: for once,
and contrary to what I did during all my ST years, I cared
about how it looked / its design rather than its pure perf.
So I used mutiple dots per star to create a little trail for
example, which makes it look cooler (like that old favorite,
the hyperspace starfield in Star Wars). In the old days I
would have considered using multiple dots per star an obvious
waste of CPU time! Foolish, I was. In any case this code has
a lot of defines for different versions. The one captured in
the provided source file is actually in fullscreen. It takes
a while to precompute but it looks cool. The more you wait,
the more stars you get on screen.

"Hack" is how I used that code for the Sommarhack 2019 compo.
I was right in the middle of playing with that stuff when the
starfield compo was announced, so I couldn't resist - it was
fate. The Sommarhack variation has a MOD song just because,
but it's not in fullscreen because it had to run on a 520 ST
and IIRC that screen took ~519000 bytes, so, nope.

"Subpixel" is just a test of subpixel accuracy for 3D polygons.
I never tried that before on ST (I started subpixel stuff on
the PC later), so I wanted to see how it looked. Not sure it's
worth it but feel free to play with it. There's nothing really
clever in that one, except a cool trick (unrelated to subpixel)
to change the triangulation of the cube's quad at runtime, to
select the one that takes less CPU time to draw. (It might be
that a more clever fill routine would have a more constant
drawing time and wouldn't need that, but in my case it helped
keeping that cube running in one vbl).

Oh man.... I just wrote "one vbl". When was the last time I
said that? Nobody says "one vbl" anymore.

So, there. I might come back to this stuff later but 2020 was
sucky for plenty of reasons, nothing happened on the ST front
for me, and it's unclear whether I'll have any time for it
in the future. Just in case, I'm releasing it in case you find
it useful.

- Pierre

