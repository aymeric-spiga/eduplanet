#! /bin/bash

echo "*** download all the correlated-k absorption coefficient databases"
cd ../RUN/DATAGENERIC/corrk_data/

if [[ ! (-f "megaCO2") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/megaCO2.zip"
fi
unzip megaCO2.zip
rm -f megaCO2.zip


if [[ ! (-f "Earth_1mbarH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_1mbarH2O.zip"
fi
unzip Earth_1mbarH2O.zip
rm -f Earth_1mbarH2O.zip


cd ../../..
