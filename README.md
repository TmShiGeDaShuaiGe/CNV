# CNV_XHMM

Ths project is to detect copy numebr variation (CNV) in Whole-Exome Seqeuncing Data. The current goal is to dealing with the bam files in odre to get the vcf file.


## Materials and software preparation

1. [GATK](https://software.broadinstitute.org/gatk/download/) 
1. [XHMM](http://atgu.mgh.harvard.edu/xhmm/tutorial.shtml) <br />
The scripts in XHMM source directories (`stagen-xhmm-\*/source/scripts`) including `interval_list_to_pseq_reg` will be used.
1. [PLINK/SEQ](http://atgu.mgh.harvard.edu/plinkseq/download.shtml) <br />
In addition to PLINK/SEQ software, the Core resource databases (hg19) is also required to be downloaded from the PLINK project home page.<br />
`$ pseq . loc-load --file refseq-hg19.gtf.gz --group refseq --locdb locdb`
1. [UCSC database](https://genome.ucsc.edu/cgi-bin/hgTables) <br />
Data resources of RefSeq (e.g., `refseq-hg19.gtf.gz`), CCDS, and GENCODE transcripts in hg19 version with GTF fromat are required to be downloaded from UCSC database.<br />
The following instractions is to explain how to download all RefSeq genes records between the position range chr7:26906938-26940301 on the May 2004 human genome assembly.
    1. Set **clade** with `Mammal`.
    1. Set **genome** with `Human`.
    1. Set **assembly** with `Feb 2009 (GRCh37/hg19)`.
    1. Set **group** with `Genes and Gene Predictions`.
    1. Set **track** with `RefSeq Genes`.
    1. Set **table** with `refGene`.
    1. Set **output format** with `GTF - gene transfer format`. Note: do not use brower to display and save the results
    1. Set **output file** with `refseq-hg19.gtf`.
    1. Clike **get output** button.

## Workflow

### PART I

The lists of BRSRed BAM files, generated from the upstream steps, are used as input files in this step.

1. Calculate sequencing depths using GATK with the shell `run_depthOfCoverage.group.MT.sh` which invokes `combine_depth_of_coverage.sh`.
1. Combine sequencing depths outputed by GATK with `combine_depth_of_coverage.sh`.  


### PART II

All processes are writte in the `main.sh` file.



## Tips

1. A XHMM standard workflow is available on XHMM home page and reference 4.
1. To use shell scripts, software path should be exposed by writting in the `~/.bashrc` file. 
1. The qsub system is used for preparation of read depth data.
1. The version of human genome database should be **hg19**.



## Abbrivation

1. MT : Min Tang <br />
1. BQSR : Base Quility Score Recaribation <br />




## Reference

1.	Fromer M, Moran JL, Chambert K, et al. Discovery and statistical genotyping of copy-number variation from whole-exome sequencing depth. Am J Hum Genet. Oct 5 2012;91(4):597-607. 
1.	Li H, Durbin R. Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics. Jul 15 2009;25(14):1754-1760.
1.	McKenna A, Hanna M, Banks E, et al. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res. Sep 2010;20(9):1297-130.
1.  Menachem Fromer and Shaun M. Purcell. Using XHMM software to detect copy number variation in whole-exome sequencing data. In Current Protocols in Human Genetics. John Wiley and Sons, Inc., 2014.


