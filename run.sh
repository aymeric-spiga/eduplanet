#! /bin/bash

## info: dossier 38x36 dans corrk --> option -i 38 -v 36

usefcm=1
#------------------------------------------------------------------
# On ciclad or climserv, load a recent gfortran compiler
hostname=`hostname`
case ${hostname:0:6} in
   ciclad|camelo|merlin) module load gnu/7.2.0 ;
     echo Loaded gnu/7.2.0 ;;
esac
#------------------------------------------------------------------
# Opening compiler setting file

if [ $# -eq 1 ]
then
  setupfile=$1
else
  setupfile="reglages_compiler.txt"
fi

if ! [ -e $setupfile ]
then
  echo "Sorry, $setupfile file does not exist."
  exit
fi

# Setting the variables
for skey in keyname keynx keyny keynz keytr keybir keybvi keydyn keyrestart keyquick ; do
  if [ "`grep -c $skey $setupfile`" = 0 ] ; then
    echo $skey is not specified in $setupfile;
    exit
  else
    paramval=`grep $skey $setupfile | awk '{print $1}' | tail -n 1`
    case $skey in
      keyname) name=$paramval && echo $skey=$name ;; 
      keydyn) dyncore=$paramval && echo $skey=$dyncore ;; 
      keyrestart) isrestart=$paramval && echo $skey=$isrestart ;; 
      keynx) nx=$paramval && echo $skey=$nx ;;
      keyny) ny=$paramval && echo $skey=$ny ;; 
      keynz) nz=$paramval && echo $skey=$nz ;; 
      keytr) tr=$paramval && echo $skey=$tr ;; 
      keybir) bir=$paramval && echo $skey=$bir ;; 
      keybvi) bvi=$paramval && echo $skey=$bvi ;; 
      keyquick) quick=$paramval && echo $skey=$quick ;;
      *) echo "Unknown option"
         exit;;
    esac
  fi
done

# Activating the dynamical core if necessary
case $dyncore in
  0) cppkey="-cpp NODYN" ;;
  1) cppkey="" ;;
  *) echo "Wrong value of the -dyn option"
     exit ;;
esac

# Simulation folder
zedate=`date --rfc-3339=seconds | sed s+' '+'_'+g | sed s+':'+'-'+g | awk -F '+' '{print $1}'`
dirname="exp_"$name"_"$zedate
echo "*** Simulation folder : $dirname"
#------------------------------------------------------------------


## script
##-------

thisfolder=$PWD
mod=$PWD/MODELES/
gcmexec="gcm_"$nx"x"$ny"x"$nz"_phystd_seq.e"
if [[ $quick == 0 ]]; then

echo "*** COMPILATION GCM *** ne pas interrompre ***"
## perform makbands here 
## to be sure to take into account
## changes in bir and/or bvi  
cd $mod/LMDZ.COMMON/libf/phystd/bands
\rm bands.$bir.$bvi > /dev/null 2> /dev/null
./makbands $bir $bvi > /dev/null 2> /dev/null
## OK now compile GCM
# In case a previous compilation went wrong...
\rm $mod/LMDZ.COMMON/libf/grid/dimensions.h 2> /dev/null
if [ $usefcm -eq 1 ] ; then
  fcmpath=$mod/FCM_V1.2/bin
  PATH=$PATH:$fcmpath
  cd $mod/LMDZ.COMMON
  \rm "bin/"$gcmexec 2> /dev/null
  ./makelmdz_fcm $cppkey -d $nx"x"$ny"x"$nz \
    -b $bir"x"$bvi -t $tr -s 1 \
    -io noioipsl \
    -p std -arch gfortran_mod gcm > logcompilegcm 2> logcompilegcm
  if [[ ! -f "bin/"$gcmexec ]] ; then 
    echo "Il y a eu un probleme. Voir : " $PWD/logcompilegcm ; exit
  fi
else
  cd $mod/LMDZ.COMMON ; \rm gcm.e 2> /dev/null
  ./makelmdz $cppkey -d $nx"x"$ny"x"$nz -b $bir"x"$bvi -t $tr -s 1 \
    -io noioipsl \
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
    \rm "bin/"$newstartexec 2> /dev/null
    ./makelmdz_fcm -d $nx"x"$ny"x"$nz -p std \
      -io noioipsl \
      -arch gfortran_mod newstart > logcompilenewstart 2> logcompilenewstart
    if [[ ! -f "bin/"$newstartexec ]] ; then
      echo "Il y a eu un probleme. Voir : " $PWD/logcompilenewstart ; exit
    fi
  else
    cd $mod/LMDZ.COMMON ; \rm newstart.e 2> /dev/null
    ./makelmdz -d $nx"x"$ny"x"$nz -p std \
      -io noioipsl \
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
  \rm gcm.e 2> /dev/null
  ln -sf "bin/"$gcmexec gcm.e
fi

# Create new folder where simulation is run
cd $thisfolder
mkdir $dirname
cp INIT/planet_start   $dirname/reglages_init.txt
cp RUN/etu.def         $dirname/reglages_run.txt
cp RUN/gases.def       $dirname/reglages_gases.txt
cp $setupfile          $dirname/$setupfile
sed 's/keyexp/'$dirname'/g' \
  TOOLS/atlas.ipynb >> $dirname/atlas.ipynb
sed 's/keyexp/'$dirname'/g' \
  TOOLS/atlas-dyn.ipynb >> $dirname/atlas-dyn.ipynb

for ifile in callphys.def gcm.e run.def startfi.nc \
  start.nc traceur.def z2sig.def gases.def etu.def ; do
  cp -L RUN/$ifile $dirname/.  2> /dev/null
done

cp -r RUN/def_benj_earth $dirname/.
cp -r RUN/def_saturn $dirname/.

if [[ $isrestart == 1 ]]; then
  restartdir=`head -n 1 reglages_restart.txt`
  if [[ ! -d $restartdir ]]; then
    echo "Desole mais le dossier $restartdir n'existe pas ;"
    exit
  fi
  echo "-----------------------------------------------------------"
  echo "On redemarre de l'etat final de la simulation :"
  echo $restartdir
  echo "-----------------------------------------------------------"
  if [[ ! -f $restartdir/restart.nc ]] ||
    [[ ! -f $restartdir/restartfi.nc ]]; then
    echo "Desole, mais cette simulation ne contient pas de fichiers"
    echo "finaux ; elle ne s'est peut-etre pas termine correctement;"
    exit
  else
    cp -f $restartdir/restart.nc $dirname/start.nc
    cp -f $restartdir/restartfi.nc $dirname/startfi.nc
  fi
fi

cd $dirname
ln -s ../RUN/DATAGENERIC .

### >>> run gcm command
time ./gcm.e | tee log_gcm | grep "Ls =" | grep '0\.'
### <<< run gcm command

mv diagfi.nc resultat.nc

echo "*** FIN ***"
