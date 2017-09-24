#! /bin/sh
#$ -S /bin/bash

cwd="/home/mt3138/whicap_xhmm"
cd $cwd

script="/home/mt3138/whicap_xhmm/scripts/depthOfcoverage.sh"
log="-cwd -e s4.errlog -o s4.errlog"

for ((i=0;i<=0;i++))
do
  li="/home/mt3138/whicap_xhmm/processed/jobBatchs/batch$i.list"
  echo "batch #:	$i"
  echo "list file:	$li"
  qsub -N batch${i}_1 -v list=$li $log $script
done

