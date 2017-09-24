#! /bin/sh
#$ -S /bin/bash

echo $id
echo $bam

jar="/home/mt3138/software/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar"
ref="/mnt/mfs/hgrcgrid/shared/GATK_Resources/2.8/b37/human_g1k_v37_decoy.fasta"
indel1kg="/home/mt3138/GATK/GATK_Resources/1000G_phase1.indels.b37.vcf"
indel="/home/mt3138/GATK/GATK_Resources/Mills_and_1000G_gold_standard.indels.b37.vcf"
dbsnp="/home/mt3138/GATK/GATK_Resources/dbsnp_137.b37.vcf "
target="/home/mt3138/whicap_GATK/targets/SeqCap_EZ_Exome_v3_capture.bed"
out="/mnt/mfs/hgrcgrid/data/nih/WHICAP/WHICAP_WES/BAM/washeiDragenBamsList/washeiBamsUpdate2/BQSR/bqsrTable/${id}.BQSR.recal.table"

java -Xmx7G \
-jar $jar \
-T BaseRecalibrator \
-R $ref \
-ip 50 \
-knownSites $dbsnp \
-knownSites $indel \
-knownSites $indel1kg \
-L $target \
--filter_mismatching_base_and_quals \
-I $bam \
-o $out



