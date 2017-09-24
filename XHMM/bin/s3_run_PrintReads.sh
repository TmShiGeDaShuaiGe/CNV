#! /bin/sh
#$ -S /bin/bash

wd="/home/mt3138/whicap_xhmm/"
cd $wd

script="./scripts/PrintReads.sh"
log="-cwd -e s3.errlog -o s3.errlog"
bamRGfolder="/mnt/mfs/hgrcgrid/data/nih/WHICAP/WHICAP_WES/BAM/washeiDragenBamsList/washeiBamsUpdate2/BQSR/RGbam"
tableFolder="/mnt/mfs/hgrcgrid/data/nih/WHICAP/WHICAP_WES/BAM/washeiDragenBamsList/washeiBamsUpdate2/BQSR/bqsrTable"
outFolder="/mnt/mfs/hgrcgrid/data/nih/WHICAP/WHICAP_WES/BAM/washeiDragenBamsList/washeiBamsUpdate2/BQSR/bqsrRGbam"

for bam in $bamRGfolder/washei25748.RG.bam
do
  id=`basename $bam | sed 's/.RG.bam//'`
  i=`basename $id | sed 's/washei/No/'`
  table=$tableFolder/$id.BQSR.recal.table
  outBam=$outFolder/$id.BQSR.recaled.bam
  echo "No:     $i"
  echo "id:     $id"
  echo "bam:    $bam"
  qsub -N $i -v id=$id -v bam=$bam -v table=$table -v outBam=$outBam $log $script
done
