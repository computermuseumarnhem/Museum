#!/usr/bin/perl -w

while ( <DATA> ) {
	chomp;

	my ( $num, $date, $part, $year ) = split /\t/;


	my $label = sprintf( "DEC-S8-OSYSB-B-PB%d", $num );
	my $code =  "NR";
	my $desc = "OS/8 V3C OPERATING SYSTEM";
	$part = "($part.bn)" unless $part =~ / /;
	my $desc1 = sprintf( "TAPE %d of 25 %s", $num, $part );
	$year ||= "1969,74,76";
	
	mkdir $label unless -d $label;
	open OUT, ">", "$label/ppt.ini";
	print OUT << "END";
[label]
code=$code
date=$date
desc=$desc
desc1=$desc1
desc2=
format=old
label=$label
year=$year
END

	close OUT;

}


__DATA__
1	9/30/76	build
2	05/17/77	build handlers tape #1\n(file structured handlers)
3	06/22/77	build handlers tape #2\n(characters oriented handlers)
4	03/31/77	os/8
5	04/20/77	(command decoder)
6	04/04/77	fort	1975
7	06/22/77	sabr
8	03/18/77	loader	1975
9	12/15/77	libset	1975
10	05/02/77	cref
11	04/20/77	edit
12	04/20/77	pal8
13	04/05/77	pip
14	04/20/77	mcpip
15	01/05/77	bitmap
16	08/05/76	epic
17	10/07/76	srccom
18	06/23/77	ccl
19	01/05/77	fotp
20	06/22/77	resorc
21	01/12/77	direct
22	04/20/77	pip10
23	01/05/77	camp
24	12/29/76	boot
25	06/22/77	rxcopy
