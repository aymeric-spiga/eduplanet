#! /bin/bash

nx=8
ny=8
nz=16
dyncore=0

while getopts "x:y:z:-:" options; do
  case $options in
   x) nx=${OPTARG};;
   y) ny=${OPTARG};;
   z) nz=${OPTARG};;
   -) case $OPTARG in # --dyn long option
        dyn) dyncore=1
             echo "Dynamical core turned on";;
        *) echo "Unknown option $OPTARG"
           exit;;
      esac;;
   *) echo "Unknown option"
      exit;;
  esac
done

case $dyncore in
  0) cppkey="-cpp NODYN" ;;
  1) cppkey="" ;;
  *) echo "Wrong value of the -dyn option"
     exit ;;
esac

######
tr=7
######

thisfolder=$PWD
wheresource=$PWD/MODELES/
b1=32
b2=36
b1=3 # recompile with full if you changed this
b2=2 # recompile with full if you changed this
b1=1 # recompile with full if you changed this
b2=1 # recompile with full if you changed this

echo "*** COMPILATION GCM *** ne pas interrompre ***"
cd $wheresource/LMDZ.COMMON ; \rm gcm.e
./makelmdz $cppkey -d $nx"x"$ny"x"$nz -b $b1"x"$b2 -t $tr -s 1 \
  -p generic -arch gfortran_mod gcm > logcompilegcm 2> logcompilegcm
if [[ ! -f gcm.e ]] ; then 
  echo "Il y a eu un probleme. Voir : " $PWD/logcompilegcm ; exit
fi

echo "*** COMPILATION NEWSTART *** ne pas interrompre ***"
cd $wheresource/LMDZ.GENERIC ; \rm newstart.e
./makegcm_gfortran_local -d $nx"x"$ny"x"$nz -debug newstart > logcompilerestart 2> logcompilerestart
if [[ ! -f newstart.e ]] ; then 
  echo "Il y a eu un probleme. Voir : " $PWD/logcompilenewstart ; exit
fi

echo "*** INITIALISATION ***"
cd $thisfolder/INIT ; \rm restartfi.nc restart.nc > /dev/null 2> /dev/null
./newstart.e < planet_start > log_newstart 2> log_newstart
if [[ ! -f restart.nc ]] ; then
  echo "Il y a eu un probleme. Voir : " $PWD/log_newstart ; exit 
fi

echo "*** SIMULATION ***"
cd $thisfolder/RUN ; \rm resultat.nc > /dev/null 2> /dev/null
time ./gcm.e | tee log_gcm | grep "Ls ="
#time gcm.e > /dev/null 2> /dev/null
#time gcm.e #| grep "WRITE"
zedate=`date --rfc-3339=seconds | sed s+' '+'_'+g | sed s+':'+'-'+g | sed s:'+':'-':g`
#mv diagfi.nc ../resultat_$zedate.nc

echo "*** SAUVEGARDE DANS : expnum_$zedate"
cd $thisfolder
mkdir expnum_$zedate
mv RUN/diagfi.nc expnum_$zedate/resultat.nc
ln -sf expnum_$zedate/resultat.nc .
cp INIT/planet_start expnum_$zedate/reglages_init.txt
cp RUN/etu.def expnum_$zedate/reglages_run.txt

echo "*** FIN ***"
