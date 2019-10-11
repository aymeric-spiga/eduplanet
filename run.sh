#! /bin/bash

## info: dossier 38x36 dans corrk --> option -i 38 -v 36

usefcm=1

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
mod=$PWD/MODELES/

if [[ $quick == 0 ]]; then

echo "*** COMPILATION GCM *** ne pas interrompre ***"
## perform makbands here 
## to be sure to take into account
## changes in bir and/or bvi  
cd $mod/LMDZ.COMMON/libf/phystd/bands
\rm bands.$bir.$bvi > /dev/null 2> /dev/null
./makbands $bir $bvi > /dev/null 2> /dev/null
## OK now compile GCM
if [ $usefcm -eq 1 ] ; then
  fcmpath=$mod/FCM_V1.2/bin
  cd $mod/LMDZ.COMMON
  gcmexec="gcm_"$nx"x"$ny"x"$nz"_phystd_seq.e"
  \rm "bin/"$gcmexec
  ./makelmdz_fcm -fcm_path $fcmpath $cppkey -d $nx"x"$ny"x"$nz \
    -b $bir"x"$bvi -t $tr -s 1 \
    -p std -arch gfortran_mod gcm > logcompilegcm 2> logcompilegcm
  if [[ ! -f "bin/"$gcmexec ]] ; then 
    echo "Il y a eu un probleme. Voir : " $PWD/logcompilegcm ; exit
  fi
else
  cd $mod/LMDZ.COMMON ; \rm gcm.e
  ./makelmdz $cppkey -d $nx"x"$ny"x"$nz -b $bir"x"$bvi -t $tr -s 1 \
    -p std -arch gfortran_mod gcm > logcompilegcm 2> logcompilegcm
  if [[ ! -f gcm.e ]] ; then 
    echo "Il y a eu un probleme. Voir : " $PWD/logcompilegcm ; exit
  fi
fi


if [[ $isrestart == 0 ]]; then

  echo "*** COMPILATION NEWSTART *** ne pas interrompre ***"
  if [ $usefcm -eq 1 ] ; then
    cd $mod/LMDZ.COMMON
    newstartexec="newstart_"$nx"x"$ny"x"$nz"_phystd_seq.e"
    \rm "bin/"$newstartexec
    ./makelmdz_fcm -fcm_path $fcmpath -d $nx"x"$ny"x"$nz -p std \
      -arch gfortran_mod newstart > logcompilenewstart 2> logcompilenewstart
    if [[ ! -f "bin/"$newstartexec ]] ; then
      echo "Il y a eu un probleme. Voir : " $PWD/logcompilenewstart ; exit
    fi
  else
    cd $mod/LMDZ.COMMON ; \rm newstart.e
    ./makelmdz -d $nx"x"$ny"x"$nz -p std \
      -arch gfortran_mod newstart > logcompilenewstart 2> logcompilenewstart
    if [[ ! -f newstart.e ]] ; then 
      echo "Il y a eu un probleme. Voir : " $PWD/logcompilenewstart ; exit
    fi
  fi
  echo "*** INITIALISATION ***"
  if [ $usefcm -eq 1 ] ; then
    cd $mod/LMDZ.COMMON
    ln -sf "bin/"$newstartexec newstart.e
  fi
  cd $thisfolder/INIT ; \rm restartfi.nc restart.nc > /dev/null 2> /dev/null
  ./newstart.e < planet_start > log_newstart 2> log_newstart
  if [[ ! -f restart.nc ]] ; then
    echo "Il y a eu un probleme. Voir : " $PWD/log_newstart ; exit 
  fi

fi

fi

echo "*** SIMULATION ***"
if [ $usefcm -eq 1 ] ; then
  cd $mod/LMDZ.COMMON
  ln -sf "bin/"$gcmexec gcm.e
fi
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
