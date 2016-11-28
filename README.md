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
    1. Set **genome** with `Human`.
    1. Set **assembly** with `May 2004 (NCBI35/hg17)`.
    1. Set **group** with `Genes and Gene Predictions`.
    1. Set **track** with `RefSeq Genes`.
    1. Set **region** with **position**, and input `chr7:26906938-26940301` into **position** field. 
    1. Clike **get output** button.


## Workflow

### PART I
 The input files are lists of BRSRed bam files generated from the upstream steps.  
1. Run GATK depth of coverage to get sequencing depths.<br />
		`run_depthOfCoverage.group.MT.sh` invoke `combine_depth_of_coverage.sh`.  
1. combine GATK depth of converage outputs. `combine_depth_of_coverage.sh`.  

### PART II

  please see `main.sh`.   

## Tips

1. You can consult the XHMM standard workflow at its homepage. Or consult the whole procedure from ref.[4]
1. In all of the shell scrits, the single funcation name is used by exposing the absolute path in the `~/.bashrc` file in the Linux System.
1. In the preparation of Read depth data, the qsub serial command lines are used.
1. Please take care the vertion of human database, since here we use hg19.<br />

## Abbrivation

1. MT : Min Tang <br />
1. BQSR : Base Quility Score Recaribation <br />

## Reference

1.	Fromer M, Moran JL, Chambert K, et al. Discovery and statistical genotyping of copy-number variation from whole-exome sequencing depth. Am J Hum Genet. Oct 5 2012;91(4):597-607. 
1.	Li H, Durbin R. Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics. Jul 15 2009;25(14):1754-1760.
1.	McKenna A, Hanna M, Banks E, et al. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res. Sep 2010;20(9):1297-130.
1.  Menachem Fromer and Shaun M. Purcell. Using XHMM software to detect copy number variation in whole-exome sequencing data. In Current Protocols in Human Genetics. John Wiley and Sons, Inc., 2014.
