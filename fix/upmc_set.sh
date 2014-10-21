#! /bin/bash

### in main folder run
### ./fix/upmc_set.exe

safetytest=`echo $PWD | grep -c fix`
if [ $safetytest -ne 0 ]
then
  echo "Ne pas executer ce script dans le dossier fix."
  echo "Executer ce script depuis eduplanet avec la commande:"
  echo "./fix/upmc_set.exe"
  exit
fi

px="proxyweb.upmc.fr"
po="3128"

whereisplanetoplot=$PWD/planetoplot

touch yorgl
echo "[global]" >> yorgl
echo "http-proxy-host = $px" >> yorgl
echo "http-proxy-port = $po" >> yorgl
mkdir -p $HOME/.subversion 
mv $HOME/.subversion/servers $HOME/.subversion/servers.bak
mv yorgl $HOME/.subversion/servers
#cat $HOME/.subversion/servers

touch .wgetrc
echo "use_proxy=on" >> .wgetrc
echo "http_proxy=$px:$po" >> .wgetrc
echo "ftp_proxy=$px:$po" >> .wgetrc
mv -f .wgetrc $HOME/
#cat $HOME/.wgetrc

num=`grep -c 3T054 $HOME/.bashrc`
if [ $num -eq 0 ]
then
  echo 'if [ -f $HOME/.bashrc.3T054 ]; then . $HOME/.bashrc.3T054; fi' >> $HOME/.bashrc
fi

\rm $HOME/.bashrc.3T054
echo 'export PATH=/opt/epd-7.1-2-rh5-x86/bin:$PATH' > $HOME/.bashrc.3T054
echo "export PYTHONPATH=$whereisplanetoplot:"'$PYTHONPATH' >> $HOME/.bashrc.3T054
echo "export PATH=$whereisplanetoplot:"'$PATH' >> $HOME/.bashrc.3T054

echo "!!!!!!!!!!!!!!!!!!!!!!!!"
echo "taper la commande"
echo " source ~/.bashrc"
echo "!!!!!!!!!!!!!!!!!!!!!!!!"


