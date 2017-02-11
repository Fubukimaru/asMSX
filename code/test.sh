#!/bin/bash
echo "Running asMSX build validation test"
cd ../code
AS=../src/asmsx
#AS=asmsx0161
rm -f ~* *.bin *.cas *.sym *.txt *.wav *.rom
$AS g-monkey.asm
$AS mine.asm
$AS pong.asm
$AS robots.asm
$AS zone.asm
rm -f ~* *.txt *.sym
sha1sum -c test.sha1 > test.output 2> test.error

