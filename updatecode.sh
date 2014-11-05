#! /bin/bash

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
