Notes
=====

PS/2 Keyboard issues:

Volgens http://www.netbsd.org/ports/sparc/javastation.html:

	The banner the JavaStation-1 displays at boot-time indicates
	which boot ROM is present. If it displays "OpenBoot 2.30", it
	has OpenBoot PROM 2. If it displays "OpenBoot 3.x" (where x is
	usually 10 or 11), it has Open Firmware.

	Unfortunately, the OpenBoot PROM 2 does not properly initialize
	the PS/2 style keyboard/mouse controller. This means you can't
	configure the PROM without a serial console. The NetBSD/sparc
	kernel supports PS/2 keyboards, so you can use the keyboard once
	the NetBSD kernel is loaded.

	Open Firmware has no PS/2 keyboard/mouse issues.

