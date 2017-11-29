#! /bin/bash

echo "*** download all the correlated-k absorption coefficient databases"
cd ../RUN/DATAGENERIC/corrk_data/

if [[ ! (-f "megaCO2") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk/megaCO2.zip"
fi
unzip megaCO2.zip
rm -f megaCO2.zip
cd ../../..
