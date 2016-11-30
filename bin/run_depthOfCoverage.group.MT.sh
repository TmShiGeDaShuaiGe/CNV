#! /bin/sh
#$ -S /bin/bash

script="/home/mt3138/whicap_XHMM/depthOfCoverage.group.MT.sh"
argus="-q big.q -cwd -e /home/mt3138/whicap_XHMM/log -o /home/mt3138/whicap_XHMM/log"

for ((i=90;i<=99;i++))
do
	echo $i
	li="/home/mt3138/whicap_XHMM/list/BQSR.bam.$i.list"
	qsub -N dc$i -v group=$i -v li=$li $argus $script
done

# BQSR.bam.$i.list is a list of BQSRed bam files.

