#! /bin/sh
#$ -S /bin/bash

# Directory path settings.
WORKSPACE_PATH="/home/mt3138/whicap_XHMM"
DATA_PATH="/mnt/mfs/hgrcgrid/shared"

# Software path settings.
GATK_PATH="/mnt/mfs/hgrcgrid/homes/mt3138/software/GenomeAnalysisTK-3.6"
GATK="java -Xmx3G -jar "${GATK_PATH}"/GenomeAnalysisTK.jar"

XHMM_PATH=${WORKSPACE_PATH}"/software/statgen-xhmm-cc14e528d909"
XHMM_PARAMS=${XHMM_PATH}"/params.txt"
interval_list_to_pseq_reg=${XHMM_PATH}"/sources/scripts/interval_list_to_pseq_reg"

# Data materials (see README.md to download)
REF=${DATA_PATH}"/GATK_Resources/2.8/b37/human_g1k_v37_decoy.fasta"
DBSNP=${DATA_PATH}"/GATK_Resources/dbsnp_137.b37.vcf"
TARGET=${WORKSPACE_PATH}"/SeqCap_EZ_Exome_v3_capture.interval_list"
seqdb=${WORKSPACE_PATH}"/XHMM_Resource/seqdb.hg19"
DATA=${WORKSPACE_PATH}"/DATA.RD.txt" # output from step 1 and step 2, by which get read depth metric 

# step 3. Optionally, run GATK to calculate the per-target GC content and create a list of the targets with extreme GC content:
# 3.1
out1=${WORKSPACE_PATH}"/DATA.locus_GC.txt"
out2=${WORKSPACE_PATH}"/extreme_gc_targets.txt"
$GATK \
 -R $REF \
 -T GCContentByInterval \
 -L $TARGET \
 -o $out1
#3.2
cat $out1 | awk '{if ($2 < 0.1 || $2 > 0.9) print $1}' > $out2

#echo "-----------------------------------------------------------------------------------------------"
# step 4. Optionally, run PLINK/Seq to calculate the fraction of repeat-masked bases in each target and create a list of those to filter out. These four optional steps calculate the fraction of repeat-masked bases (Smit and Hubley, 2008) in each target and creates a list of targets with low complexity for you to filter out up front.
out3=${WORKSPACE_PATH}"/EXOME.targets.reg"
out4=${WORKSPACE_PATH}"/EXOME.targets.LOCDB.loc-load"
out5=${WORKSPACE_PATH}"/DATA.locus_complexity.txt"
out6=${WORKSPACE_PATH}"/low_complexity_targets.txt"
LOCDB=${WORKSPACE_PATH}"/EXOME.targets.LOCDB" # it is a output file

##if bed file is in the chr:bp1-bp2 format
#cat ${TARGET} | \
#awk 'BEGIN{OFS="\t"; print "#CHR\tBP1\tBP2\tID"} {split($1,a,":"); chr=a[1]; if (match(chr,"chr")==0) {chr="chr"chr} split(a[2],b,"-"); bp1=b[1]; bp2=bp1; if (length(b) > 1) {bp2=b[2]} print chr,bp1,bp2,NR}' \
#> ./EXOME.targets.reg
# 4.1. Convert exome target list to Plink/Seq format
$interval_list_to_pseq_reg $TARGET > $out3
#awk 'BEGIN{OFS="\t"; print "#CHR\tBP1\tBP2\tID"}; {print "chr"$1,$2,$3,NR}' $TARGET >./EXOME.targets.reg
# 4.2. Load exome target list into a Plink/Seq exome database file
pseq . loc-load --file $out3 --group targets --locdb $LOCDB --out $out4 
# 4.3. Run Plink/Seq to calculate the per-target repeat-masking fraction (download the seqdb file along with the Plink/Seq code, as described above)
pseq . loc-stats --group targets --seqdb $seqdb --locdb $LOCDB | awk '{if (NR > 1) print $_}' | sort -k1 -g | awk '{print $10}' | paste ${TARGET} - | awk '{print $1"\t"$2}' > $out5
##E.G. pseq . loc-stats --locdb ./EXOME.targets.LOCDB --group targets --seqdb ${WORKSPACE_PATH}/seqdb.hg19 | awk '{if (NR > 1) print $_}' | sort -k1 -g | awk '{print $10}' | paste /home/mt3138/whicap_GATK/targets/SeqCap_EZ_Exome_v3_capture.bed - | awk '{print $1"\t"$2}' > DATA.locus_complexity.txt
# 4.4. Create a list of all exome targets to be excluded, based on the fraction of repeat- masked sequence (as calculated by RepeatMasker; Smit and Hubley, 2008)
cat $out5 | awk '{if ($2 > 0.25) print $1}' > $out6

echo "-----------------------------------------------------------------------------------------------"
# step 5. Use the XHMM matrix command to process the read-depth matrix. Filters samples and targets and then mean-centers the targets:
out7=${WORKSPACE_PATH}"/DATA.filtered_centered.RD.txt"
out8=${WORKSPACE_PATH}"/DATA.filtered_centered.RD.txt.filtered_targets.txt"
out9=${WORKSPACE_PATH}"/DATA.filtered_centered.RD.txt.filtered_samples.txt"
xhmm --matrix \
 --centerData \
 --centerType target \
 --minTargetSize 10 \
 --maxTargetSize 10000 \
 --minMeanTargetRD 10 \
 --maxMeanTargetRD 500 \
 --minMeanSampleRD 25 \
 --maxMeanSampleRD 200 \
 --maxSdSampleRD 150 \
 -r $DATA \
 --outputExcludedTargets $out8 \
 --outputExcludedSamples $out9 \
 --excludeTargets $out2 \
 -o $out7 

# --excludeTargets $out6 \ #temproy do not use this argument 

echo "-----------------------------------------------------------------------------------------------"
# step 6. Runs PCA on mean-centered data:
out10=${WORKSPACE_PATH}"/DATA.RD_PCA"
xhmm --PCA \
 -r $out7 \
 --PCAfiles $out10 
#This outputs 3 files to be used in the next step:
     #a. DATA.RD_PCA.PC.txt: the data projected into the principal components
     #b. DATA.RD_PCA.PC_LOADINGS.txt: the loadings of the samples on the principal components 
     #c. DATA.RD_PCA.PC_SD.txt: the variance of the input read depth data in each of the principal components

echo "-----------------------------------------------------------------------------------------------"
# step 7. Remove the top principal components and reconstruct a normalized read depth matrix. Normalizes mean-centered data using PCA information:
out11=${WORKSPACE_PATH}"/DATA.PCA_normalized.txt"
xhmm --normalize \
 --PCnormalizeMethod PVE_mean \
 --PVE_mean_factor 0.7 \
 -r $out7 \
 --PCAfiles $out10 \
 --normalizeOutput $out11

echo "-----------------------------------------------------------------------------------------------"
# step 8. Filters and z-score centers (by sample) the PCA-normalized data:
out12=${WORKSPACE_PATH}"/DATA.PCA_normalized.filtered.sample_zscores.RD.txt"
out13=${WORKSPACE_PATH}"/DATA.PCA_normalized.filtered.sample_zscores.RD.txt.filtered_targets.txt"
out14=${WORKSPACE_PATH}"/DATA.PCA_normalized.filtered.sample_zscores.RD.txt.filtered_samples.txt"
xhmm --matrix \
 --centerData \
 --centerType sample \
 --zScoreData \
 --outputExcludedTargets $out13 \
 --outputExcludedSamples $out14 \
 --maxSdTargetRD 30 \
 -r $out11 \
 -o $out12 

echo "-----------------------------------------------------------------------------------------------"
# step 9. Filters original read-depth data to be the same as filtered, normalized data:
out15=${WORKSPACE_PATH}"/DATA.same_filtered.RD.txt"
xhmm --matrix \
 --excludeTargets $out8 \
 --excludeTargets $out13 \
 --excludeSamples $out9 \
 --excludeSamples $out14 \
 -r $DATA \
 -o $out15

echo "-----------------------------------------------------------------------------------------------"
## step 10.Run the HMM Viterbi algorithm to call CNVs in each sample. Discovers CNVs in normalized data:
xcnv=${WORKSPACE_PATH}"/DATA.xcnv"
aux_xcnv=${WORKSPACE_PATH}"/DATA.aux_xcnv"
out16=${WORKSPACE_PATH}"/DATA"
xhmm --discover \
 -p $XHMM_PARAMS \
 -r $out12 \
 -R $out15 \
 -c $xcnv \
 -a $aux_xcnv \
 -s $out16

echo "-----------------------------------------------------------------------------------------------"
## step 11. Genotypes discovered CNVs in all samples:
#vcf=${WORKSPACE_PATH}"/DATA.vcf"
#xhmm --genotype \
# -p $XHMM_PARAMS \
# -r $out10 \
# -R $out11 \
# -g $xcnv \
# -F $REF \
# -v $vcf

echo "-----------------------------------------------------------------------------------------------"
#locdb=${WORKSPACE_PATH}"/XHMM_Resource/locdb"
## step12. Annotate exome targets with their corresponding genes:
#out12=${WORKSPACE_PATH}"/annotated_targets.refseq"
#pseq . loc-intersect --group refseq --locdb $locdb --file $TARGET --out $out12 


## Building the resource databases
# Gene transcripts (LOCDB)
# pseq . loc-load --file refseq-hg19.gtf.gz --group refseq --locdb locdb
# pseq . loc-load --file ccds-hg19.gtf.gz --group ccds --locdb locdb.ccds
# pseq . loc-load --file gencodeBasicV11-hg19.gtf.gz --group gencode --locdb locdb.gencode
