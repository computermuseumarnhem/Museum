#!/bin/sh

exec picocom \
	--baud 9600 \
	--flow x \
	--parity e \
	--databits 7 \
	$1
