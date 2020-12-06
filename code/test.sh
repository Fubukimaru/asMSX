#!/bin/bash
echo "Running asMSX build validation test"

# Change to code dir
CODEDIR=$(dirname $(find . -maxdepth 2 -name 'test.sh'))
cd $CODEDIR
CODEDIR=$PWD

echo $PWD

AS=$(readlink -f $PWD/../asmsx)
#AS=asmsx0161

rm -f ~* *.bin *.cas *.sym *.txt *.wav *.rom

for FILE in $(find . -maxdepth 1 -name '*.asm'); do 
  $AS $FILE
  echo ""
done

cd wrally
$AS src/rally.asm 
mv src/rally.z80 ..

cd $CODEDIR

rm -f ~* *.txt *.sym
sha1sum -c test.sha1 > test.output 2> test.error

cat test.output
cat test.error

if [ -s test.error ]
then
    echo "There were errors!"
    exit 1
fi

# Cleanup data
rm -f *.bin *.cas *.sym *.txt *.wav *.rom
rm test.output test.error
