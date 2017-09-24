#! /bin/sh
#$ -S /bin/bash

echo $id
echo $bam

bamRGfolder="/mnt/mfs/hgrcgrid/data/nih/WHICAP/WHICAP_WES/BAM/washeiDragenBamsList/washeiBamsUpdate2/BQSR/RGbam"

# reheader
samtools view -H $bam | sed 's/DT:2015-...../DT:2016081700/' |  sed 's/DT:2016-...../DT:2016081700/' | sed 's/DT:2015.............../DT:2016081700/' | sed 's/DT:2016.............../DT:2016081700/' | samtools reheader - $bam > $bamRGfolder/$id.RG.bam
samtools index  $bamRGfolder/$id.RG.bam

