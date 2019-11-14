#! /bin/bash

lmdzserv="http://www.lmd.jussieu.fr/~lmdz/pub/3DInputData/Generic/"

echo "*** record local changes"
#git add INIT/planet_start
#git add RUN/etu.def
#git commit -m "save local"
mv INIT/planet_start.earth INIT/planet_start.earth.backup
mv RUN/etu.def RUN/etu.def.backup

echo "*** update eduplanet"
git pull

echo "*** update LMD models"
cd MODELES
svn update -r 2168
cd ..

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
