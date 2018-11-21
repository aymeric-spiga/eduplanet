#! /bin/bash

echo "*** download all the correlated-k absorption coefficient databases"
cd ../RUN/DATAGENERIC/corrk_data/

if [[ ! (-f "megaCO2") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/megaCO2.zip"
fi
unzip megaCO2.zip
rm -f megaCO2.zip

if [[ ! (-f "Earth_1mbarH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_1mbarH2O.zip"
fi
unzip Earth_1mbarH2O.zip
rm -f Earth_1mbarH2O.zip

if [[ ! (-f "Earth_0.1mbarH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_0.1mbarH2O.zip"
fi
unzip Earth_0.1mbarH2O.zip
rm -f Earth_0.1mbarH2O.zip

if [[ ! (-f "Earth_10mbarH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_10mbarH2O.zip"
fi
unzip Earth_10mbarH2O.zip
rm -f Earth_10mbarH2O.zip

if [[ ! (-f "Earth_100mbCO2_1mbH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_100mbCO2_1mbH2O.zip"
fi
unzip Earth_100mbCO2_1mbH2O.zip
rm -f Earth_100mbCO2_1mbH2O.zip

if [[ ! (-f "Earth_100mbCO2_2mbCH4_1mbH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_100mbCO2_2mbCH4_1mbH2O.zip"
fi
unzip Earth_100mbCO2_2mbCH4_1mbH2O.zip
rm -f Earth_100mbCO2_2mbCH4_1mbH2O.zip

if [[ ! (-f "Earth_900ppmCO2_1mbH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_900ppmCO2_1mbH2O.zip"
fi
unzip Earth_900ppmCO2_1mbH2O.zip
rm -f Earth_900ppmCO2_1mbH2O.zip

if [[ ! (-f "Earth_900ppmCO2_900ppmCH4_1mbH2O") ]] ; then
  wget "http://www.lmd.jussieu.fr/~mturbet/eduplanet/corrk_data/Earth_900ppmCO2_900ppmCH4_1mbH2O.zip"
fi
unzip Earth_900ppmCO2_900ppmCH4_1mbH2O.zip
rm -f Earth_900ppmCO2_900ppmCH4_1mbH2O.zip




cd ../../..
