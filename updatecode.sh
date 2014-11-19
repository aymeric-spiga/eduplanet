#! /bin/bash

echo "*** record local changes"
git add INIT/planet_start
git add RUN/etu.def
git commit -m "save local"

echo "*** update eduplanet"
git pull

echo "*** update LMD models"
cd MODELES
svn update
cd ..

echo "*** update planetoplot"
cd planetoplot
git pull
cd ..

echo "*** get supplementary files"
cd RUN/DATAGENERIC
if [[ ! (-f "surface_earth.nc") ]] ; then
  wget "http://www.lmd.jussieu.fr/~aslmd/planetoplot/surface_earth.nc"
fi
if [[ ! (-f "surface_mars.nc") ]] ; then
  wget "http://www.lmd.jussieu.fr/~aslmd/planetoplot/surface_mars.nc"
fi
cd ../..
