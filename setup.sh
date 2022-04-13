#!/bin/bash

edufolder=$PWD
codedir="MODELES/LMDZ.GENERIC/"
deftank="$codedir/deftank/"
phystd="$codedir/libf/phystd/"
datagen="RUN/DATAGENERIC/"
corrkwww="https://web.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/"

userexit=0

if [[ ! -f run.sh ]]
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
  1 > Default "billard ball"
  2 > Earth present day topo
  3 > Earth + water cycle
  4 > Earth + water cycle + slab ocean
      (ongoing work...)
  5 > Earth with specified supercontinent
  6 > Titan
  7 > Trappist
  8 > Mars
  9 > Show available topographies
> Radiative transfer setup
  51 > Greenhouse gases
> Setup tools :
  61 > Compute orbital parameters
  62 > Change albedo of continents
  63 > Change obliquity
> Apply a specific patch :
  71 > Albedo feedback
  72 > Add radiative fluxes to outputs
  79 > Disable all patches
> Turn on the dynamical core (dyn)
  81 > Earth 16x16x16 or 32x32x16
  82 > Titan 16x16x28 or 32x32x28
  83 > Trappist 16x16x28 or 32x32x28
> File operations :
  91 > Show folder sizes
  92 > Delete one folder
  93 > Restart from previous run
  94 > Recap all settings
> 0 > Exit
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
   3) cat INIT/planet_start.earth.continents > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.default > reglages_run.txt
      cat RUN/etu.def.watercycle >> reglages_run.txt
      echo "Don't forget to turn on the dynamical core" && sleep 2 ;;
   # CONFIG 4 NE FONCTIONNE PAS POUR L'INSTANT
   4) cat INIT/planet_start.earth.slabocean > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.default > reglages_run.txt
      cat RUN/etu.def.watercycle >> reglages_run.txt
      cat RUN/etu.def.slabocean >> reglages_run.txt
      echo "Don't forget to turn on the dynamical core" && sleep 2 ;;
   5) cat INIT/planet_start.earth.supercontinent > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.default > reglages_run.txt 
      echo "Solar constant value at 1 astronomical unit ?"
      read Fat1AU
      # comment lines that contain Fat1AU
      sed -i '/Fat1AU/ s/^#*/#/' reglages_run.txt
      # add the wanted value after each occurrence
      sed -i "/Fat1AU/a Fat1AU = $Fat1AU" reglages_run.txt ;;
   6) cat INIT/planet_start.titan > reglages_init.txt
      cat INIT/compiler.titan > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.titan > reglages_run.txt ;;
   7) cp -v $deftank/stellar_spectra/Flux_TRAPPIST1.dat $datagen/stellar_spectra/. 
      cp -v $deftank/stellar_spectra/lambda_TRAPPIST1.dat $datagen/stellar_spectra/. 
      cat INIT/planet_start.trappist > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.trappist > reglages_run.txt ;;
   8) cat INIT/planet_start.mars.continents > reglages_init.txt
      cat INIT/compiler.default > reglages_compiler.txt
      cat RUN/gases.def.default > reglages_gases.txt
      cat RUN/etu.def.default > reglages_run.txt ;;
   9) cd INIT/DATAGENERIC
      ls surface_*.nc 
      cd $edufolder ;;
  #----------------------------------------------------------------
   51) cat <<EOL
      1 > earth
      2 > megaCO2
      3 > Earth_1mbarH2O (not available yet)
      4 > Earth_0.1mbarH2O (not available yet)
      5 > Earth_10mbarH2O (not available yet)
      6 > Earth_100mbCO2_1mbH2O (not available yet)
      7 > Earth_100mbCO2_2mbCH4_1mbH2O (not available yet)
      8 > Earth_900ppmCO2_1mbH2O
      9 > Earth_900ppmCO2_900ppmCH4_1mbH2O (not available yet)
      ----
      Please select a gas mix :
EOL
      read gasmixnb
      case $gasmixnb in
        1) gasmix="earth"
           echo $gasmix ;;
        2) gasmix="megaCO2"
           echo $gasmix ;;
        3) gasmix="Earth_1mbarH2O"
           echo $gasmix not available yet && continue ;;
        4) gasmix="Earth_0.1mbarH2O"
           echo $gasmix not available yet && continue ;;
        5) gasmix="Earth_10mbarH2O"
           echo $gasmix not available yet && continue ;;
        6) gasmix="Earth_100mbCO2_1mbH2O"
           echo $gasmix not available yet && continue ;;
        7) gasmix="Earth_100mbCO2_2mbCH4_1mbH2O"
           echo $gasmix not available yet && continue ;;
        8) gasmix="Earth_900ppmCO2_1mbH2O"
           echo $gasmix ;;
        9) gasmix="Earth_900ppmCO2_900ppmCH4_1mbH2O"
           echo $gasmix not available yet && continue ;;
        *) echo Unknown option && continue ;;
      esac
      #### download corrk_data
      case $gasmixnb in
        [1-9]*) cd $datagen"/corrk_data"
           if [[ ! (-d "$gasmix") ]] ; then
             wget $corrkwww"/"$gasmix".zip"
             unzip $gasmix".zip"
             rm -fv $gasmix".zip"
           else
             echo $gasmix folder found
           fi
           cd $edufolder
           #### setup etu.def
           echo "" >> reglages_run.txt
           echo "# Radiative transfer setup" >> reglages_run.txt
           echo "#   "$gasmix >> reglages_run.txt
           echo "corrkdir = $gasmix" >> reglages_run.txt
           echo "graybody = .false." >> reglages_run.txt
           #### setup gases.def
           cat "RUN/gases.def.$gasmix" > reglages_gases.txt ;;
      esac
      #### setup number of bands in compiler options
      #### (make sure to use 3 digits!)
      case $gasmixnb in
        #earth
        1) nbir="38 "
           nbvi="36 ";;
        #megaCO2
        2) nbir="8  "
           nbvi="12 ";;
        #Earth_900ppmCO2_1mbH2O
        8) nbir="38 "
           nbvi="36 ";;
      esac
      # replace the three first digits to specify band number
      sed -ri "/keybir/ s/^(.{0})(.{3})/$nbir/" reglages_compiler.txt
      sed -ri "/keybvi/ s/^(.{0})(.{3})/$nbvi/" reglages_compiler.txt ;;
  #----------------------------------------------------------------
   61) python TOOLS/peri_day.py ;;
   62) topofile=`grep "surface_" reglages_init.txt | head -n 1`
       newfile="surface_user-settings.nc"
       if [ -f $datagen/$topofile ] ; then
         echo $topofile" found ;"
         echo "Which albedo to you want to set on continents ?"
         read newalb
         ncap2 -O -s "where(thermal < 18000.) albedo=$newalb" \
           $datagen/$topofile $datagen/$newfile
         if [ -f $datagen/$newfile ] ; then
           echo "New file can be found in $datagen/$newfile"
         else
           echo "New file not created ; there's been a problem"
         fi
       else
         echo "No topo file set in reglages_init.txt"
       fi ;;
   63) echo "New obliquity ?"
       read obliquit
       sed -i \
         "/obliquit/{n;s/.*/$obliquit !! <-- Obliquite (degres)/}" \
         reglages_init.txt ;;
  #----------------------------------------------------------------
   71) patch ./$phystd/physiq_mod.F90 < PLUG-INS/icealbedo.patch ;;
   72) patch ./$phystd/physiq_mod.F90 < PLUG-INS/radfluxes.patch ;;
   79) cd ./$phystd
       svn revert physiq_mod.F90 
       cd $edufolder ;;
  #----------------------------------------------------------------
   81) cat RUN/etu.def.dyn.earth >> reglages_run.txt ;;
   82) cat RUN/etu.def.dyn.titan >> reglages_run.txt ;;
   83) cat RUN/etu.def.dyn.trappist >> reglages_run.txt ;;
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
   94) for ifile in reglages_*.txt ; do
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "$ifile":"
         cat $ifile
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> end"
       done ;;
  #----------------------------------------------------------------
    *) echo "Unknown option;" ;;
  esac
  
  case $userchoice in
    8?) sed -i '/keydyn/ s/^0/1/' reglages_compiler.txt 
        sed -ri "/keynx/ s/^(.{0})(.{3})/16 /" reglages_compiler.txt
        sed -ri "/keyny/ s/^(.{0})(.{3})/16 /" reglages_compiler.txt ;;
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
