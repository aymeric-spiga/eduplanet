#!/bin/bash

thisfolder=$PWD


echo "Hello student !"
echo "You are on "`hostname`
echo "You are about to change settings in order to get starting configuration for the exoplanet TRAPPIST-1g :"
echo "Do you want to continue ? (1=YES, 0=NO)"
read answer

if [ $answer -eq 1 ]
then
  cp $thisfolder/INIT/DATAGENERIC/stellar_spectra/Flux_TRAPPIST1.txt $thisfolder/INIT/DATAGENERIC/stellar_spectra/Flux_TRAPPIST1.dat
  cp $thisfolder/INIT/DATAGENERIC/stellar_spectra/lambda_TRAPPIST1.txt $thisfolder/INIT/DATAGENERIC/stellar_spectra/lambda_TRAPPIST1.dat
  echo "Obscur setting changes :"
  cp $thisfolder/INIT/newstart.F.ocean $thisfolder/MODELES/LMDZ.GENERIC/libf/dynphy_lonlat/phystd/newstart.F
  cp $thisfolder/INIT/iniphy.ocean $thisfolder/MODELES/LMDZ.GENERIC/libf/dynphy_lonlat/phystd/iniphysiq_mod.F90
  echo "Done !"
  echo "Setting reglages_init.txt :"
  rm $thisfolder/INIT/planet_start
  ln -s $thisfolder/INIT/planet_start.trappist $thisfolder/INIT/planet_start
  echo "Done !"
  echo "Setting reglages_run.txt :"
  cp $thisfolder/RUN/etu.def.trappist $thisfolder/RUN/etu.def
  echo "Done !"
  echo "Setting reglages_compiler.txt :"
  cp $thisfolder/INIT/compiler.trappist $thisfolder/reglages_compiler.txt
  echo "Done !"
fi
