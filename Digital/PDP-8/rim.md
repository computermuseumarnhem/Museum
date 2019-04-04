BIN File Format
===============

1. Leader/trailer (ASCII code 0200)
2. Self-starting Binary loader in RIM format
3. Checksum of SS BIN or two frames of leader/trailer
4. Leader/trailer or blank tape
5. Program to be loaded, beginning with an origin setting.
   If it is to be laded into a field other than the field
   of the loaders, it must also begine with a field setting.
6. An origin setting at the end of the program, if it is to 
   be started by SS BIN
7. Checksum of the program portion of the tape.
8. Leader/trailer

Leader/trailer
--------------

0b10000000  at least one inch (10 bytes)

Field setting
-------------

0b11fff000  field setting (1 byte).
	    0o300   byte


