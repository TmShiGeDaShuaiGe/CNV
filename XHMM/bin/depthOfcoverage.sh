#! /bin/sh
#$ -S /bin/bash

GATKJAR="/mnt/mfs/hgrcgrid/homes/mt3138/software/GenomeAnalysisTK-3.7/GenomeAnalysisTK.jar"
REF="/home/mt3138/GATK/GATK_Resources/human_g1k_v37.fasta"
DBSNP="/home/mt3138/GATK/GATK_Resources/dbsnp_137.b37.vcf"
TARGET="/home/mt3138/whicap_GATK/targets/SeqCap_EZ_Exome_v3_capture.bed"

JAVA="java -Xmx7G -Djava.io.tmpdir=/home/mt3138/whicap_xhmm/summary/summary_stats"
GATK="$JAVA -jar "${GATKJAR}

n=`wc -l $list | awk '{print $1}'`

for ((j=1;j<=1;j++))
do
  fil=`awk -v k=$j 'NR==k {print}' $list`
  id=`basename $fil | sed 's/.recaled.bam//'`
  out="/home/mt3138/whicap_xhmm/data/DATA/$id.DP"
  
  echo "file #:	$j"
  echo "file name:	$fil"
  echo "output filename:	$out"

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
  --includeRefNSites \
  --countType COUNT_FRAGMENTS \
  -I $fil \
  -o $out
done
