## CNV_XHMM
#### Ths project is to detect copy numebr variation (CNV) in Whole-Exome Seqeuncing Data. 
#### The current goal is to dealing with the bam files in odre to get the vcf file.

## **source** <br />
1. GATK software : https://software.broadinstitute.org/gatk/download/. <br />
2. XHMM software : http://atgu.mgh.harvard.edu/xhmm/tutorial.shtml. You can consult the XHMM standard workflow by this website.<br />
3. PLINK/SEQ serial commandlines : http://atgu.mgh.harvard.edu/plinkseq/download.shtml. please download the Core resource databases (hg19) by this website.<br />
4. Building the resource databases : GTFs from the UCSC table browser were downloaded for hg19, for RefSeq, CCDS and GENCODE transcripts
for example, download the refseq-hg19.gtf.gz from the UCSC Table Brower https://genome.ucsc.edu/cgi-bin/hgTables. <br />
$ pseq . loc-load --file refseq-hg19.gtf.gz --group refseq --locdb locdb <br />

## **Reference** <br />
1.	Fromer M, Moran JL, Chambert K, et al. Discovery and statistical genotyping of copy-number variation from whole-exome sequencing depth. Am J Hum Genet. Oct 5 2012;91(4):597-607. <br />
2.	Li H, Durbin R. Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics. Jul 15 2009;25(14):1754-1760.<br />
3.	McKenna A, Hanna M, Banks E, et al. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res. Sep 2010;20(9):1297-130. <br />
