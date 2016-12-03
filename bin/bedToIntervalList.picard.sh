#! /bin/sh
#$ -S /bin/bash

# Directory path settings.
DATA_PATH="/mnt/mfs/hgrcgrid/shared"

# Software path settings.
PICARD_PATH="/home/mt3138/software/picard-tools-2.4.1/"
PICARD="java -Xmx3G -jar "$PICARD_PATH"/picard.jar"

# Data materials (see README.md to download)
REF=${DATA_PATH}"/GATK_Resources/2.8/b37/human_g1k_v37_decoy.fasta"
TARGETbedFil=${WORKSPACE_PATH}"/SeqCap_EZ_Exome_v3_capture.bed"
TARGET=${WORKSPACE_PATH}"/SeqCap_EZ_Exome_v3_capture.interval_list"
REFdict=${PICARD_PATH}"/reference_sequence.dict"

# Create Sequecnce Dictionary
$PICARD CreateSequenceDictionary \
 R=$REF \
 O=$REFdict

# use picard converts bed file to interval_list file
$PICARD BedToIntervalList \
 SD=$REFdict \
 I=$TARGETbedFil \
 O=$TARGET

