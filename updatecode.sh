#! /bin/bash

lmdzserv="http://www.lmd.jussieu.fr/~lmdz/planets/LMDZ.GENERIC/surfaces/"

echo "*** record local changes"
git add INIT/planet_start.earth
git add RUN/etu.def
git commit -m "save local"

echo "*** update eduplanet"
git pull

echo "*** update planetoplot"
cd TOOLS/planetoplot
git pull
cd ../..

echo "*** update planets"
cd TOOLS/planets
git pull
cd ../..

echo "*** get supplementary files"
cd RUN/DATAGENERIC
if [[ ! (-f "surface_earth.nc") ]] ; then
  wget "$lmdzserv/surface_earth.nc"
fi
if [[ ! (-f "surface_mars.nc") ]] ; then
  wget "$lmdzserv/surface_mars.nc"
fi
if [[ ! (-f "surface_venus.nc") ]] ; then
  wget "$lmdzserv/surface_venus.nc"
fi
if [[ ! (-f "surface_earth_paleo.tar.gz") ]] ; then
  wget "$lmdzserv/surface_earth_paleo.tar.gz"
  tar -xvzf surface_earth_paleo.tar.gz
fi
cd ../..
