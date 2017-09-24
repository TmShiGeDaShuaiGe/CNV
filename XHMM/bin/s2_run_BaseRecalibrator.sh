#! /bin/sh
#$ -S /bin/bash

wd="/home/mt3138/whicap_xhmm/"
cd $wd

script="./scripts/BaseRecalibrator.sh"
log="-cwd -e s2.errlog -o s2.errlog"
bamRGfolder="/mnt/mfs/hgrcgrid/data/nih/WHICAP/WHICAP_WES/BAM/washeiDragenBamsList/washeiBamsUpdate2/BQSR/RGbam"

for bam in $bamRGfolder/washei25748.RG.bam
do
  id=`basename $bam | sed 's/.RG.bam//'`
  i=`basename $id | sed 's/washei/No/'`
  echo "No:     $i"
  echo "id:     $id"
  echo "bam:    $bam"
  qsub -N $i -v id=$id -v bam=$bam $log $script
done

# this script is used to generate second recal table, usually not used.
# second pass evaluates what the data looks like after recalibration
# finally, you can use the two tables to make plots (i.e., AnalyzeCovariates.sh)
