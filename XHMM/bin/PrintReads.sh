#! /bin/sh
#$ -S /bin/bash

echo $id
echo $bam
echo $table
echo $outBam

jar="/home/mt3138/software/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar"
ref="/mnt/mfs/hgrcgrid/shared/GATK_Resources/2.8/b37/human_g1k_v37_decoy.fasta"

java -Xmx7G -jar $jar -T PrintReads -R $ref -I $bam -BQSR $table -o $outBam
