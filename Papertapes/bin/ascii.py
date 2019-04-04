#!/usr/bin/env python3
# vim: set sw=4 sts=4 si et:

file = open( "content.raw", "rb" )

data = file.read()

for byte in data:

    byte = byte & 0x7f

    if byte > 0:
        print( chr( byte ), end="" )

