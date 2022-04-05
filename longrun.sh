#!/bin/bash

if [ "`which qsub`" = "" ] ; then
  echo "qsub is not present on this machine"
  echo "abort"
  exit
fi

jobid=$$
loginuser=`whoami`-$jobid
sed 's/keyexpname/'$loginuser'/' longrun.qsub > longrun-$jobid.qsub

echo "This script must be used to submit long runs to the cluster"
echo "You are on "`hostname`
echo "Here is the config file you are about to submit :"
echo "-----------------"
cat longrun-$jobid.qsub
echo "-----------------"
echo "Do you want to continue ? (1=YES, 0=NO)"
read answer

if [ $answer -eq 1 ]
then
  qsub longrun-$jobid.qsub
  echo "Job has been submitted :"
  qstat -u `whoami`
  echo "To see job status, use :"
  echo qstat -u `whoami`
  echo "To cancel job, use qdel followed by the job id number."
fi
