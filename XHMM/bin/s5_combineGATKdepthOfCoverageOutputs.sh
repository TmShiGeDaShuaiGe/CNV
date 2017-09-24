#! /bin/sh
#$ -S /bin/bash

wd="/home/mt3138/whicap_xhmm/data/DATA"
cd $wd

xhmm --mergeGATKdepths -o ../WHICAP_WES.DATA.RD.txt \
  --GATKdepths washei25748.DATA.sample_interval_summary \
  --GATKdepths washei25756.DATA.sample_interval_summary \
  --GATKdepths washei25759.DATA.sample_interval_summary \
  --GATKdepths washei25762.DATA.sample_interval_summary \
  --GATKdepths washei25772.DATA.sample_interval_summary \
  --GATKdepths washei25773.DATA.sample_interval_summary \
  --GATKdepths washei25775.DATA.sample_interval_summary \
  --GATKdepths washei25786.DATA.sample_interval_summary \
  --GATKdepths washei25796.DATA.sample_interval_summary \
  --GATKdepths washei25896.DATA.sample_interval_summary \
  --GATKdepths washei25922BL3.DATA.sample_interval_summary
