#!/bin/bash

thisfolder=$PWD


echo "Hello student !"
echo "You are on "`hostname`
echo "Here you can apply patches for specific numerical experiments :"
echo "List of patches avalaible :"
ls $thisfolder/PLUG-INS
echo "Which patch do you want (enter 0 to quit) ? :"
echo "Or enter 99 to return to default settings ? :"
read answer


patch $thisfolder/MODELES/LMDZ.GENERIC/libf/phystd/physiq_mod.F90 < PLUG-INS/$answer



if [ $answer -eq 99 ]
then
  svn revert $thisfolder/MODELES/LMDZ.GENERIC/libf/phystd/physiq_mod.F90
fi
