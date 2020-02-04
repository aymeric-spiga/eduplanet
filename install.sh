#! /bin/bash
# 03/08/2014 -- A. Spiga
# install the generic model 
# with gfortran on Linux env
# for teaching purposes

#######################
version="1359"
version="1370"
version="HEAD"
version="2233"
#######################
usefcm=1
#######################
zedim="8x8x16"
#######################
zeoptall=" -d "${zedim}" -p std -arch gfortran_mod "
zeopt=${zeoptall}" -full -cpp NODYN -b 1x1 -t 3 -s 1 -io noioipsl "
#######################


ini=$PWD
mod=$ini/MODELES
net=$mod/LMDZ.COMMON/netcdf/gfortran_netcdf-4.0.1
log=$ini/install.log
\rm $log > /dev/null 2> /dev/null
touch $log

##
echo "1. communicate with server"
cd $ini
rm -rf MODELES
svn co -N http://svn.lmd.jussieu.fr/Planeto/trunk MODELES >> $log 2>&1

###
echo "2. get model code (please wait)"
cd $mod
svn update -r $version LMDZ.GENERIC LMDZ.COMMON >> $log 2>&1

###
echo "3. get and compile netCDF librairies (please wait)"
cd $ini
ze_netcdf=netcdf-4.0.1
wget http://www.lmd.jussieu.fr/~lmdz/Distrib/$ze_netcdf.tar.gz -a $log
tar xzvf $ze_netcdf.tar.gz >> $log 2>&1
\rm $ze_netcdf.tar.gz*
export FC=gfortran 
export FFLAGS=" -O2"
export F90=gfortran 
export FCFLAGS="-O2 -ffree-form"
export CPPFLAGS="" 
export CC=gcc
export CFLAGS="-O2"
export CXX=g++
export CXXFLAGS="-O2"
cd $ze_netcdf 
PREFIX=$PWD
./configure --prefix=${PREFIX} >> $log 2>&1  #--disable-cxx
make >> $log 2>&1
make test >> $log 2>&1
make install >> $log 2>&1
cd ..
mkdir $ini/MODELES/LMDZ.COMMON/netcdf
mv $ze_netcdf $net

# in case netcdf was compiled in 64bits:
if [ -d $net/lib64 ] && !( [ -d $net/lib ] )
then
  ln -sf lib64 $net/lib
fi

####
#echo "4. get and compile IOIPSL librairies (please wait)"
##cp $ini/fix/install_ioipsl_gfortran_noksh.bash $mod/LMDZ.COMMON/ioipsl/install_ioipsl_gfortran.bash
#cd $mod/LMDZ.COMMON/ioipsl
##sed -i s+"/home/aymeric/Science/MODELES"+$mod+g install_ioipsl_gfortran.bash
#./install_ioipsl_gfortran.bash >> $log 2>&1
#ls -l $mod/LMDZ.COMMON/ioipsl/modipsl/lib

###
echo "5. customize arch files"
cd $mod/LMDZ.COMMON/arch
cp arch-gfortran.fcm arch-gfortran_mod.fcm
cp arch-gfortran.path arch-gfortran_mod.path
echo NETCDF=$net > arch-gfortran_mod.env

###
echo "6. compile the model fully at least once (please wait)"
if [ $usefcm -eq 1 ] ; then
  cd $mod
  svn co http://forge.ipsl.jussieu.fr/fcm/svn/PATCHED/FCM_V1.2 >> $log 2>&1
  fcmpath=$mod/FCM_V1.2/bin
  cd $mod/LMDZ.COMMON
  ./makelmdz_fcm -j 8 -fcm_path $fcmpath $zeopt gcm >> $log 2>&1
else
  cd $mod/LMDZ.COMMON
  ./makelmdz                        $zeopt gcm >> $log 2>&1
fi
###
echo "7. compile the program for initial condition at least once (please wait)"
cd $mod/LMDZ.COMMON
if [ $usefcm -eq 1 ] ; then
  ./makelmdz_fcm -j 8 -fcm_path $fcmpath $zeoptall newstart >> $log 2>&1
else
  ./makelmdz $zeoptall newstart >> $log 2>&1
fi

#### previous old local method
#cd $mod/LMDZ.GENERIC
#sed s+"/donnees/emlmd/netcdf64-4.0.1_gfortran"+$net+g makegcm_gfortran > makegcm_gfortran_local
#chmod 755 makegcm_gfortran_local
#./makegcm_gfortran_local -d 8x8x6 -debug newstart >> $log 2>&1

###
echo "8. get post-processing tools"
cd $ini/TOOLS
rm -rf planetoplot
git clone https://github.com/aymeric-spiga/planetoplot >> $log 2>&1
rm -rf planets
git clone https://github.com/aymeric-spiga/planets >> $log 2>&1

###
cd $ini
mv $log $mod/
