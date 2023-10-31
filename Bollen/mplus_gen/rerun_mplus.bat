@echo off

for f in mplus_gen/*.mplus.in
do
  FILE=`basename $f .mplus.in`
  mplus mplus_gen/$FILE.mplus.in $FILE.mplus.out
done
