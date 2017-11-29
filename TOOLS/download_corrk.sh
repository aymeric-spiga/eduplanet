#! /bin/bash

echo "*** download all the correlated-k absorption coefficient databases"
cd ../RUN/DATAGENERIC/corrk/

if [[ ! (-f "megaCO2") ]] ; then
  wget -r "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk/megaCO2"
fi
cd ../../..
