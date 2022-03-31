#!/bin/bash

edufolder=$PWD
phystd="MODELES/LMDZ.GENERIC/libf/phystd/"

if [[ ! -e run.sh ]]
then
  echo "Make sure you run this script from the eduplanet root"
  echo "directory, alongside the run.sh file, using ./setup.sh"
  exit
fi

cat <<EOL
----------------------------------------------
       eduplanet quick setup menu

> Setup a new simulation :
  1) Default "billard ball" - no dyn
  2) Earth present day topo - no dyn
  3) Earth with slab ocean - no dyn
  9) Show available topographies
> Apply a specific patch :
  71) Albedo feedback
  79) Disable all patches
> 91) Clean simulation directories
> 0) Exit
----------------------------------------------
EOL

read userchoice
case $userchoice in
 0) exit ;;
 1) cat INIT/planet_start.earth > reglages_init.txt
    cat INIT/compiler.default > reglages_compiler.txt
    cat RUN/gases.def.default > reglages_gases.txt
    cat RUN/etu.def.default > reglages_run.txt ;;
 2) cat INIT/planet_start.earth.continents > reglages_init.txt
    cat INIT/compiler.default > reglages_compiler.txt
    cat RUN/gases.def.default > reglages_gases.txt
    cat RUN/etu.def.default > reglages_run.txt ;;
 3) cp $edufolder/INIT/newstart.F.ocean $edufolder/$phystd/newstart.F
    cp $edufolder/INIT/iniphy.ocean $edufolder/$phystd/iniphysiq_mod.F90
    cat INIT/planet_start.earth.continents > reglages_init.txt
    cat RUN/etu.def.ocean > reglages_run.txt
    cat RUN/gases.def.default > reglages_gases.txt
    cat INIT/compiler.ocean > reglages_compiler.txt ;;
 9) cd INIT/DATAGENERIC
    ls surface_*.nc ;;
#------------------------------------------------------------------
 71) patch ./$phystd/physiq_mod.F90 < PLUG-INS/icealbedo.patch ;;
 79) cd ./$phystd
     svn revert physiq_mod.F90 
     cd $edufolder ;;
#------------------------------------------------------------------
 91) find . -maxdepth 1 -type d -iname "exp_*" -print | \
       awk '{print NR"-> "$1}'
     echo "Which folder do you want to delete ?"
     read delnumber
     deldirname=`find . -maxdepth 1 -type d -iname "exp_*" -print | \
       awk -v linenb=$delnumber 'NR==linenb {print $1}'`
     rm -frv $deldirname ;;
#------------------------------------------------------------------
  *) echo "Unknown option; Exiting;"
     exit ;;
esac

# WORK IN PROGRESS : TRAPPIST
#cp $thisfolder/INIT/DATAGENERIC/stellar_spectra/Flux_TRAPPIST1.txt $thisfolder/INIT/DATAGENERIC/stellar_spectra/Flux_TRAPPIST1.dat
#cp $thisfolder/INIT/DATAGENERIC/stellar_spectra/lambda_TRAPPIST1.txt $thisfolder/INIT/DATAGENERIC/stellar_spectra/lambda_TRAPPIST1.dat
#cp $thisfolder/INIT/newstart.F.ocean $thisfolder/MODELES/LMDZ.GENERIC/libf/dynphy_lonlat/phystd/newstart.F
#cp $thisfolder/INIT/iniphy.ocean $thisfolder/MODELES/LMDZ.GENERIC/libf/dynphy_lonlat/phystd/iniphysiq_mod.F90
#rm $thisfolder/INIT/planet_start
#ln -s $thisfolder/INIT/planet_start.trappist $thisfolder/INIT/planet_start
#cp $thisfolder/RUN/etu.def.trappist $thisfolder/RUN/etu.def
#cp $thisfolder/INIT/compiler.trappist $thisfolder/reglages_compiler.txt
