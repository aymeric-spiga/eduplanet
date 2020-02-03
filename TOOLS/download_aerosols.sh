#! /bin/bash

echo "*** download all the correlated-k absorption coefficient databases"
cd ../RUN/DATAGENERIC/

if [[ ! (-f "optprop_dustvis_n50.dat") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/aerosols_data/optprop_dustvis_n50.dat"
fi

if [[ ! (-f "optprop_dustir_n50.dat") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/aerosols_data/optprop_dustir_n50.dat"
fi

cd ../..
