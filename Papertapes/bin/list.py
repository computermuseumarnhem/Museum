#!/usr/bin/env python3
# vim: set sw=4 sts=4 si et:

ascii_names = [
    "NUL",
    "SOH",
    "STX",
    "ETX",
    "EOT",
    "ENQ",
    "ACK",
    "BEL",
    "BS",
    "HT",
    "LF",
    "VT",
    "FF",
    "CR",
    "SO",
    "SI",
    "DLE",
    "DC1",
    "DC2",
    "DC3",
    "DC4",
    "NAK",
    "SYN",
    "ETB",
    "CAN",
    "EM",
    "SUM",
    "ESC",
    "FS",
    "GS",
    "RS",
    "US",
    "SPACE"
]

def clean( byte ):
    if ( byte < 32 ):
        return "%-3s ^%1s" % ( ascii_names[ byte ], chr( byte + 64 ) )
    if ( byte == 32 ):
        return "SPACE"
    if ( byte == 127 ):
        return "DEL"
    if ( byte > 127 ):
        return ''
    return chr( byte )

def ppt( byte ):
    left = bin( byte >> 3 )[2:].rjust( 5 )
    right = bin( byte & 0b111 )[2:].rjust( 2 )
    s = left + "." + right
    return s.translate( {48: 32, 49: 111, 46: 46} )

fh = open( "content.raw", "rb" )

data = fh.read()

address = 0

print( "%s\t%s\t%s\t%s\t%s\t%s" % ( " ADDR", "DEC", "HEX", "OCT", "CHAR", " PPT" ) )

for byte in data:
    
    print( "%5d:\t%3d\t%02x\t%03o\t%s\t|%-9.9s|" %
        ( address, byte, byte, byte, clean( byte ), ppt( byte ) ) 
    ) 

    address += 1
