echo "System:"
uname -rso
# Author: E. Millour

echo ""
echo "Checking shell:"
which ksh
which bash
if [ "`which ksh`" = "" ] ; then
  echo "no ksh ... we will use bash"
  use_shell="bash"
  if [ "`which bash`" = "" ] ; then
    echo "ksh (or bash) needed!! Install it!"
  fi
fi

echo ""
echo "Checking for utilities:"
for logiciel in csh svn wget tar gzip make gfortran gcc ; do
which $logiciel
if [ "`which $logiciel`" = "" ] ; then
echo "You must install $logiciel on your system"
exit
fi
done

echo ""
echo "Checking for NetCDF visualization tools:"
for logiciel in ferret grads ; do
which $logiciel
if [ "`which $logiciel`" = "" ] ; then
echo "You should install $logiciel on your system"
fi
done

echo ""
echo "For eduplanet/eduearth, you also need Python 2.7 and the following modules:"
echo "from mpl_toolkits.basemap import Basemap"
echo "import netCDF4"
echo "(you can use these commands inside Python to check if they are installed)"
