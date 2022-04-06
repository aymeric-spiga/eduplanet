#!/bin/bash

edufolder=$PWD
codedir="MODELES/LMDZ.GENERIC/"
deftank="$codedir/deftank/"
phystd="$codedir/libf/phystd/"
datagen="RUN/DATAGENERIC/"
userexit=0

if [[ ! -e run.sh ]]
then
  echo "Make sure you run this script from the eduplanet root"
  echo "directory, alongside the run.sh file, using ./setup.sh"
  exit
fi

# Functions
#------------------------------------------------------------------
select_folder () {
  local delnumber
  local linenb
  find . -maxdepth 1 -type d -iname "exp_*" -print | \
         awk '{print NR"-> "$1}'
  read delnumber
  selectdir=`find . -maxdepth 1 -type d -iname "exp_*" -print | \
    awk -v linenb=$delnumber 'NR==linenb {print $1}'`
}

#------------------------------------------------------------------
while [ $userexit -eq 0 ]
do
  
  cat <<EOL
----------------------------------------------
       eduplanet quick setup menu

> Setup a new simulation (nodyn)
  1) Default "billard ball"
  2) Earth present day topo
  3) Earth with slab ocean
  4) Earth with specified supercontinent
  5) Titan
  6) Trappist
  9) Show available topographies
> Apply a specific patch :
  71) Albedo feedback
  79) Disable all patches
> Turn on the dynamical core (dyn)
  81) Earth 16x16x16 or 32x32x16
  82) Titan 16x16x28 or 32x32x28
> File operations :
  91) Show folder sizes
  92) Delete one folder
  93) Restart from previous run
> 0) Exit
----------------------------------------------
EOL
  
  read userchoice
  case $userchoice in
   0) userexit=1 ;;
   1) cat INIT/planet_start.earth > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.default > reglages_run.txt ;;
   2) cat INIT/planet_start.earth.continents > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.default > reglages_run.txt ;;
   # CONFIG 3 A VALIDER
   3) cp $edufolder/INIT/newstart.F.ocean $edufolder/$phystd/newstart.F
      cp $edufolder/INIT/iniphy.ocean $edufolder/$phystd/iniphysiq_mod.F90
      cat INIT/planet_start.earth.continents > reglages_init.txt
      cat RUN/etu.def.ocean > reglages_run.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat INIT/compiler.ocean > reglages_compiler.txt ;;
   4) cat INIT/planet_start.earth.supercontinent > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.default > reglages_run.txt ;;
   5) cat INIT/planet_start.titan > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.titan > reglages_run.txt ;;
   6) cp -v $deftank/stellar_spectra/Flux_TRAPPIST1.dat $datagen/stellar_spectra/. 
      cp -v $deftank/stellar_spectra/lambda_TRAPPIST1.dat $datagen/stellar_spectra/. 
      cat INIT/planet_start.trappist > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.trappist > reglages_run.txt ;;
   9) cd INIT/DATAGENERIC
      ls surface_*.nc ;;
  #----------------------------------------------------------------
   71) patch ./$phystd/physiq_mod.F90 < PLUG-INS/icealbedo.patch ;;
   79) cd ./$phystd
       svn revert physiq_mod.F90 
       cd $edufolder ;;
  #----------------------------------------------------------------
   81) cat RUN/etu.def.dyn.earth >> reglages_run.txt ;;
   82) cat RUN/etu.def.dyn.titan >> reglages_run.txt ;;
  #----------------------------------------------------------------
   91) du -hs exp_* | sort -rn ;;
   92) echo "Which folder do you want to delete ?"
       select_folder
       rm -frv $selectdir ;;
   93) echo "Which run do you want to use ?"
       select_folder
       sed -i "/exp_/c $selectdir" reglages_restart.txt
       echo "Do you also want to restore the same settings ?"
       echo "(1 = yes, 0 = no)"
       read answer
       if [ $answer -eq 1 ] ; then
         cat $selectdir/reglages_init.txt > reglages_init.txt
         cat $selectdir/reglages_compiler.txt > reglages_compiler.txt
         cat $selectdir/reglages_gases.txt > reglages_gases.txt
         cat $selectdir/reglages_run.txt  > reglages_run.txt
       fi ;;
  #----------------------------------------------------------------
    *) echo "Unknown option;" ;;
  esac
  
  case $userchoice in
   8?) echo "Dynamical core setup was added to reglages_run.txt"
       echo "Don't forget to change keydyn, keynx and keyny"
       echo "  accordingly in reglages_compiler.txt" ;;
  esac

done
#------------------------------------------------------------------

# WORK IN PROGRESS : TRAPPIST
#cp $thisfolder/INIT/DATAGENERIC/stellar_spectra/Flux_TRAPPIST1.txt $thisfolder/INIT/DATAGENERIC/stellar_spectra/Flux_TRAPPIST1.dat
#cp $thisfolder/INIT/DATAGENERIC/stellar_spectra/lambda_TRAPPIST1.txt $thisfolder/INIT/DATAGENERIC/stellar_spectra/lambda_TRAPPIST1.dat
#cp $thisfolder/INIT/newstart.F.ocean $thisfolder/MODELES/LMDZ.GENERIC/libf/dynphy_lonlat/phystd/newstart.F
#cp $thisfolder/INIT/iniphy.ocean $thisfolder/MODELES/LMDZ.GENERIC/libf/dynphy_lonlat/phystd/iniphysiq_mod.F90
#rm $thisfolder/INIT/planet_start
#ln -s $thisfolder/INIT/planet_start.trappist $thisfolder/INIT/planet_start
#cp $thisfolder/RUN/etu.def.trappist $thisfolder/RUN/etu.def
#cp $thisfolder/INIT/compiler.trappist $thisfolder/reglages_compiler.txt
