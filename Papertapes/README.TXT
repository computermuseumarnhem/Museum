Here I've made images of papertapes

The tapes look as follows:

- The tapes are fan-folded, not rolled-up.

- There is a label with the id, some description and copyright dates

- The data on the tape:

At the start of the tape, there is (in human readable form) the tape id, followed by "COPYRIGHT $year BY DIGITAL EQUIPMENT CORPORATION"

DEC	 HEX	 OCT	 CHAR	       PPT
---	----	----	------	-----------
  0	0x00	0000	NUL ^@	|     .   |      leading zeroes
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
...
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
128	0x80	0200		|o    .   |       sometimes followed by 0x80
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
...
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
 66	0x42	0102	B	| o   . o |       start of data
  0	0x00	0000	NUL ^@	|     .   |
 64	0x40	0100	@	| o   .   |
...
 12	0x0c	0014	FF  ^L	|    o.o  |
 62	0x3e	0076	>	|  ooo.oo |
  4	0x04	0004	EOT ^D	|     .o  |
 63	0x3f	0077	?	|  ooo.ooo|
  0	0x00	0000	NUL ^@	|     .   |
128	0x80	0200		|o    .   |       on some tapes again 0x80s
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
...
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
128	0x80	0200		|o    .   |
  0	0x00	0000	NUL ^@	|     .   |        and zeroes as end filling
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
...
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
  0	0x00	0000	NUL ^@	|     .   |
129	0x81	0201		|o    .  o|        and this construct
 66	0x42	0102	B	| o   . o |
 36	0x24	0044	$	|  o  .o  |
 24	0x18	0030	CAN ^X	|   oo.   |
 36	0x24	0044	$	|  o  .o  |
 66	0x42	0102	B	| o   . o |
129	0x81	0201		|o    .  o|
 66	0x42	0102	B	| o   . o |
 36	0x24	0044	$	|  o  .o  |
 24	0x18	0030	CAN ^X	|   oo.   |
 36	0x24	0044	$	|  o  .o  |
 66	0x42	0102	B	| o   . o |
129	0x81	0201		|o    .  o|
 66	0x42	0102	B	| o   . o |
 36	0x24	0044	$	|  o  .o  |
 24	0x18	0030	CAN ^X	|   oo.   |
 36	0x24	0044	$	|  o  .o  |
 66	0x42	0102	B	| o   . o |
129	0x81	0201		|o    .  o|
204	0xcc	0314		|oo  o.o  |
  0	0x00	0000	NUL ^@	|     .   |        followd by zeroes
  0	0x00	0000	NUL ^@	|     .   |
...
  0	0x00	0000	NUL ^@	|     .   |        
  0	0x00	0000	NUL ^@	|     .   |
                                                   and the physical end of the tape


Tools
=====

readserial.pl  reads bytes from /dev/ttyUSB0:1200,n,8,1,no handshake, and writes these to "content.raw", unless overridden (see source)
trim.pl	       filters stdin to stdout while trimming the leading zeroes, trailing zeros and the xxx thing on the end
ppt.pl         displays data as above from stdin or 1st argument

