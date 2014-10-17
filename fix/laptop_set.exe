#! /bin/bash

### in main folder run
### ./fix/laptop_set.exe

safetytest=`echo $PWD | grep -c fix`
if [ $safetytest -ne 0 ]
then
  echo "Ne pas executer ce script dans le dossier fix."
  echo "Executer ce script depuis eduplanet avec la commande:"
  echo "./fix/laptop_set.exe"
  exit
fi

whereisplanetoplot=$PWD/planetoplot

num=`grep -c eduplanet $HOME/.bashrc`
if [ $num -eq 0 ]
then
  echo 'if [ -f $HOME/.bashrc.eduplanet ]; then . $HOME/.bashrc.eduplanet; fi' >> $HOME/.bashrc
fi

\rm $HOME/.bashrc.eduplanet
echo "export PYTHONPATH=$whereisplanetoplot:"'$PYTHONPATH' >> $HOME/.bashrc.eduplanet
echo "export PATH=$whereisplanetoplot:"'$PATH' >> $HOME/.bashrc.eduplanet

echo "!!!!!!!!!!!!!!!!!!!!!!!!"
echo "taper la commande"
echo " source ~/.bashrc"
echo "!!!!!!!!!!!!!!!!!!!!!!!!"


