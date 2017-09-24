#! /bin/sh
#$ -S /bin/bash
 
wd="/home/mt3138/whicap_xhmm/"
cd $wd

script="./scripts/modifyRGDT.sh"
log="-cwd -e s1.errlog -o s1.errlog"

bamOriFolder="/mnt/mfs/hgrcgrid/data/nih/WHICAP/WHICAP_WES/BAM/washeiDragenBamsList/washeiBamsUpdate2"
for bam in $bamOriFolder/washei25748.bam
do
  id=`basename $bam | sed 's/.bam//'`
  i=`basename $id | sed 's/washei/No/'`
  echo "No:	$i"
  echo "id:	$id"
  echo "bam:	$bam"
  qsub -N $i -v id=$id -v bam=$bam $log $script
done

