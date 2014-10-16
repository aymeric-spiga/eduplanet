#! /bin/bash
# 03/08/2014 -- A. Spiga
# install the generic model 
# with gfortran on Linux env
# for teaching purposes

ini=$PWD
mod=$ini/MODELES
net=$mod/LMDZ.COMMON/netcdf/gfortran_netcdf-4.0.1
log=$ini/install.log
\rm $log > /dev/null 2> /dev/null
touch $log

###
echo "1. communicate with server"
cd $ini
rm -rf MODELES
svn co -N http://svn.lmd.jussieu.fr/Planeto/trunk MODELES >> $log 2>&1

###
echo "2. get model code (please wait)"
rm -rf planetoplot
git clone https://github.com/aymeric-spiga/planetoplot >> $log 2>&1
cd $mod
svn update -r 1321 LMDZ.GENERIC LMDZ.COMMON >> $log 2>&1
cd $mod/LMDZ.COMMON/libf
ln -sf $mod/LMDZ.GENERIC/libf/phystd phygeneric

###
echo "3. get and compile netCDF librairies (please wait)"
cd $ini
ze_netcdf=netcdf-4.0.1
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/$ze_netcdf.tar.gz -a $log
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

###
echo "4. get and compile IOIPSL librairies (please wait)"
cp $ini/fix/install_ioipsl_gfortran_noksh.bash $mod/LMDZ.COMMON/ioipsl/install_ioipsl_gfortran.bash
cd $mod/LMDZ.COMMON/ioipsl
sed -i s+"/home/aymeric/Science/MODELES"+$mod+g install_ioipsl_gfortran.bash
./install_ioipsl_gfortran.bash >> $log 2>&1

###
echo "5. customize arch files"
cd $mod/LMDZ.COMMON/arch
cp arch-gfortran.fcm arch-gfortran_mod.fcm
sed s+"/home/aymeric/Science/MODELES"+$mod+g arch-gfortran.path > arch-gfortran_mod.path

###
echo "6. compile the model fully at least once (please wait)"
cd $mod/LMDZ.COMMON
./makelmdz -full -cpp NODYN -d 8x8x16 -b 1x1 -t 3 -s 1 -p generic -arch gfortran_mod gcm >> $log 2>&1

###
echo "7. compile the program for initial condition at least once (please wait)"
cd $mod/LMDZ.GENERIC
sed s+"/donnees/emlmd/netcdf64-4.0.1_gfortran"+$net+g makegcm_gfortran > makegcm_gfortran_local
chmod 755 makegcm_gfortran_local
./makegcm_gfortran_local -d 8x8x16 -debug newstart >> $log 2>&1

###
mv $log $mod/
