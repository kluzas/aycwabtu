AYCWABTU Improved
========

overview
--------
AYCWABTU Improved is an improved version of the original AYCWABTU.

AYCWABTU is a proof of concept for a brute force control word calculation 
tool for the common scrambling algorithm used in digital video broadcasting.

AYCWABTU is not useful for live decryption of pay TV channels because the
search for one key needs much more time than the key renewal interval. Majority
of channels change keys multiple times a minute and AYCWABTU needs months to
brute force one key. AYCWABTU is intended as proof of concept, and is not
intended to be used for illegal purposes. The author does not accept
responsibility for ANY damage incurred by the use of it.

It uses parallel bit slice technique. Other csa parallel bit slice
implementations (like libdvbcsa) are meant for stream processing. They encrypt
or decrypt many packets with one key. AYCWABTU uses parallel bit slice for
decrypting one packet with many keys.


Performance Improvements over the original AYCWABTU 
---------------------------------------------------

* Different compiler flags for GCC compilation when using Linux
* Added support for OpenMP
* Small improvements on the code


Performance (Ryzen 1600 @3.6GHz) Linux:

- Initial version (Single threaded):  5 Mcw/s
- Compiler flags and code cleanup(Single threaded):   7 Mcw/s
- 6 OpenMP threads: 40 Mcw/s
- 12 OpenMP threads (SMT): 41 Mcw/s


features
--------
* Open source. License: GPL
* read three encrypted data packets from ts file with many checks for valid data
* writes a small probe ts file with these packets for sharing and distributed attack
* test frame included to make sure, it really finds the keys. Also suitable for other brute force tools
* written in C. Developed in Visual Studio 2013, tested with gcc 4.8.2+cygwin 2.844
* much potential for speed improvements


To do list
----------
* Improve the code quality
* Support for 256 bits parallel with advanced vector extensions AVX
* OpenCL support
* Optimize the block sbox boolean equations. Only slightly faster with 128 bits. See da_diett.pdf Chpt. 3.1
* Check, why aycw_block_sbox(&sbox_out) fails in gcc, possible speedup ~19%
* block decrypt first (does not depend on stream). Then stream afterwards, stop XORing immediately 
  if foreseeable there is no PES header


developers
----------
* after changing the code, run tests with SELFTEST enabled to make sure the algorithm still works. It's too easy to break things.
* run "make test"
* test all the batch size implementations
* publish all your work please, AYCWABTU is released under GPL

credits
-------
* Improved version Michail Alvanos
* Initial version ganymede
* FFdecsa, Copyright 2003-2004, fatih89r
* libdvbcsa, http://www.videolan.org/developers/libdvbcsa.html
* ANALYSIS OF THE DVB COMMON SCRAMBLING ALGORITHM, Ralf-Philipp Weinmann and Kai Wirt, Technical University of Darmstadt Department of Computer Science Darmstadt, Germany
* On the Security of Digital Video Broadcast Encryption, Markus Diett
* http://en.wikipedia.org/wiki/Common_Scrambling_Algorithm
* Breaking DVB-CSA, Erik Tews, Julian Waelde, Michael Weiner, Technische Universitaet Darmstadt
* TSDEC - the DVB transport stream offline decrypter, http://sourceforge.net/projects/tsdec/
* http://csa.irde.to   This page disappeared unfortunately but it still accessible here https://web.archive.org/web/20040903151642/http://csa.irde.to/
* and last not least my good friend johnf

