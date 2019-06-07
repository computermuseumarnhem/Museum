#!/usr/bin/env python3

# vim: set sw=4 sts=4 si et:

import sys

data = sys.stdin.buffer.read()

while ( data.length() > 0 ):

    byte = data[0]
    data = data[1:]

    if byte == 0o200:
        value = ( 'leader', )
    elif ( byte & 0o300 ) == 0o300:
        value = ( 'field', byte & 0o070 )
    elif ( byte & 0o300 ) == 0o200:
        pass
    elif ( byte & 0o300 ) == 0o100:
        byte2 = data[0]
        data  = data[1:]
        value = ( 'origin', ( byte & 0o077 ) << 6 + ( byte2 & 0o077 ) )
    elif ( byte & 0o300 ) == 0o000:
        byte2 = data[0]
        data  = data[1:]
        value = ( 'data', ( byte & 0o077 ) << 6 + ( byte2 & 0o077 ) )
    else:
        pass

    print( value )

