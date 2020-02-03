#!/bin/bash
# script to download and install the latest version of IOIPSL
# using gfortran
# You'll probably have to change paths to NetCDF library 'lib' and 'include'
# below to adapt this script to your computer.

setfolder="/home/aymeric/Science/MODELES/LMDZ.COMMON/netcdf/gfortran_netcdf-4.0.1"
#setfolder="/donnees/emlmd/netcdf64-4.0.1_gfortran/"

#0. Preliminary stuff 
# netcdf include and lib dirs:
netcdf_include=$setfolder"/include"
netcdf_lib=$setfolder"/lib"

whereami=`pwd -P`

# 1. Get IOIPSL (via modipsl)
svn co http://forge.ipsl.jussieu.fr/igcmg/svn/modipsl/trunk modipsl
cd modipsl/util

find * -exec sed -i s:ksh:bash:g {} \;
./model IOIPSL_PLUS

# 2. Set correct settings:
# modify path to netcdf in 'AA_make.gdef'
cp AA_make.gdef AA_make.gdef.old
sed -e s:"gfortran  NCDF_INC = /usr/local/include":"gfortran  NCDF_INC = ${netcdf_include}":1 \
    -e s:"gfortran  NCDF_LIB = -L/usr/local/lib":"gfortran  NCDF_LIB = -L${netcdf_lib}":1 \
    AA_make.gdef.old > AA_make.gdef

# set default working precision for IOIPSL:
./ins_make -t gfortran -p I4R8

## 3. build ioipsl:
cd ../modeles/IOIPSL/src

find * -exec sed -i s:ksh:bash:g {} \;
make

if [[ -f ${whereami}/modipsl/lib/libioipsl.a ]] 
  then
  echo "OK: ioipsl library is in ${whereami}/modipsl/lib"
else
  echo "Something went wrong..."
fi

