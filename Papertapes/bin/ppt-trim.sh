#!/bin/sh

dd if=content.raw bs=1 count=$(($2+1)) | dd of=content.bin bs=1 skip=$1
