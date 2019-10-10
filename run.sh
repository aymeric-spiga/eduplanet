#! /bin/bash

## info: dossier 38x36 dans corrk --> option -i 38 -v 36

## default
##--------

nx=8
ny=8 
nz=6
tr=2
bir=1
bvi=1
dyncore=0
isrestart=0
quick=0

## options
##--------

while getopts "x:y:z:t:i:v:-:" options; do
  case $options in
   x) nx=${OPTARG};;
   y) ny=${OPTARG};;
   z) nz=${OPTARG};;
   t) tr=${OPTARG};;  ## ne change rien si pas dynamique
   i) bir=${OPTARG};; ## combinaison doit etre dans DATAGENERIC e.g. 3 32
   v) bvi=${OPTARG};; ## combinaison doit etre dans DATAGENERIC e.g. 2 36
   -) case $OPTARG in 
        # --dyn long option
        dyn) dyncore=1
             echo "Dynamical core turned on";;
        # --restart long option
        restart) isrestart=1
                 echo "Restart run from previous one";;
        # --quick long option
        quick) quick=1;;
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

## script
##-------

thisfolder=$PWD
wheresource=$PWD/MODELES/

if [[ $quick == 0 ]]; then

echo "*** COMPILATION GCM *** ne pas interrompre ***"
## perform makbands here 
## to be sure to take into account
## changes in bir and/or bvi  
cd $wheresource/LMDZ.COMMON/libf/phystd/bands
\rm bands.$bir.$bvi > /dev/null 2> /dev/null
./makbands $bir $bvi > /dev/null 2> /dev/null
## OK now compile GCM
cd $wheresource/LMDZ.COMMON ; \rm gcm.e
./makelmdz $cppkey -d $nx"x"$ny"x"$nz -b $bir"x"$bvi -t $tr -s 1 \
  -p std -arch gfortran_mod gcm > logcompilegcm 2> logcompilegcm
if [[ ! -f gcm.e ]] ; then 
  echo "Il y a eu un probleme. Voir : " $PWD/logcompilegcm ; exit
fi

if [[ $isrestart == 0 ]]; then

  echo "*** COMPILATION NEWSTART *** ne pas interrompre ***"
  cd $wheresource/LMDZ.COMMON ; \rm newstart.e
  ./makelmdz -d $nx"x"$ny"x"$nz -p std \
    -arch gfortran_mod newstart > logcompilerestat 2> logcompilerestart
  if [[ ! -f newstart.e ]] ; then 
    echo "Il y a eu un probleme. Voir : " $PWD/logcompilenewstart ; exit
  fi

  echo "*** INITIALISATION ***"
  cd $thisfolder/INIT ; \rm restartfi.nc restart.nc > /dev/null 2> /dev/null
  ./newstart.e < planet_start > log_newstart 2> log_newstart
  if [[ ! -f restart.nc ]] ; then
    echo "Il y a eu un probleme. Voir : " $PWD/log_newstart ; exit 
  fi

fi

fi

echo "*** SIMULATION ***"
cd $thisfolder/RUN ; \rm resultat.nc > /dev/null 2> /dev/null
if [[ $isrestart == 1 ]]; then
  mv startfi.nc   startfi.nc.ref
  mv start.nc     start.nc.ref
  mv restartfi.nc startfi.nc
  mv restart.nc   start.nc
fi
### >>> run gcm command
time ./gcm.e | tee log_gcm | grep "Ls =" | grep '0\.'
### <<< run gcm command
zedate=`date --rfc-3339=seconds | sed s+' '+'_'+g | sed s+':'+'-'+g | awk -F '+' '{print $1}'`
if [[ $isrestart == 1 ]]; then
  rm -rf startfi.nc
  rm -rf start.nc
  mv startfi.nc.ref startfi.nc
  mv start.nc.ref   start.nc
fi

echo "*** SAUVEGARDE DANS : expnum_$zedate"
cd $thisfolder
mkdir expnum_$zedate
mv RUN/diagfi.nc     expnum_$zedate/resultat.nc
cp INIT/planet_start expnum_$zedate/reglages_init.txt
cp RUN/etu.def       expnum_$zedate/reglages_run.txt
ln -sf expnum_$zedate/resultat.nc .

echo "*** FIN ***"
