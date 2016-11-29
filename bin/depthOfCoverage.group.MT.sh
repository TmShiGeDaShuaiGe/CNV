#! /bin/sh
#$ -S /bin/bash

GATKJAR="/mnt/mfs/hgrcgrid/homes/mt3138/software/GenomeAnalysisTK-3.6/GenomeAnalysisTK.jar"
REF="/mnt/mfs/hgrcgrid/shared/GATK_Resources/2.8/b37/human_g1k_v37_decoy.fasta"
DBSNP="/mnt/mfs/hgrcgrid/shared/GATK_Resources/dbsnp_137.b37.vcf"
TARGET="/home/mt3138/whicap_XHMM/EXOME.interval_list"

echo "$group	$li"
OUT="/home/mt3138/whicap_XHMM/depthOfCoverage/group$group.DATA"

JAVA="java -Xmx3G -Djava.io.tmpdir=/home/mt3138/whicap_XHMM/summary/summary_stats"
GATK="$JAVA -jar "${GATKJAR}


$GATK \
 -R $REF \
 -T DepthOfCoverage \
 -L $TARGET \
 -dt BY_SAMPLE \
 -dcov 5000 \
 -l INFO \
 --omitDepthOutputAtEachBase \
 --omitLocusTable \
 --minBaseQuality 0 \
 --minMappingQuality 20 \
 --start 1 \
 --stop 5000 \
 --nBins 200 \
 -I $li \
 -o $OUT
