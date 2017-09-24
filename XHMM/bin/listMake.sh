#! /bin/sh
#$ -S /bin/bash

cwd="/home/mt3138/whicap_xhmm/processed/jobBatchs"
cd $cwd

bamLi="/home/mt3138/whicap_xhmm/processed/jobBatchs/bqsrRGbam.list"
n=`wc -l $bamLi | awk '{print $1}'`

batch=100
njobs=$(echo "scale=0; ($n/$batch) + 1" | bc)
for ((i=0;i<$njobs;i++))
do
   st=$(echo "scale=0; ($i*$batch) + 1" | bc)
   en=$(($st + $batch - 1 ))
   echo "part #: $i"
   echo "start : $st"
   echo "end   : $en"
   awk -v ST=$st -v EN=$en 'NR>=ST && NR<=EN {print}' $bamLi > batch$i.list
done
