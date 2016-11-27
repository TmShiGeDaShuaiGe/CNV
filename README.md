## CNV_XHMM
#### Ths project is to detect copy numebr variation (CNV) in Whole-Exome Seqeuncing Data. 
#### The current goal is to dealing with the bam files in odre to get the vcf file.

## **source** <br />
1. GATK software : https://software.broadinstitute.org/gatk/download/. <br />
2. XHMM software : http://atgu.mgh.harvard.edu/xhmm/tutorial.shtml. In the downloaded and uncompressed folder `statgen-xhmm-*sources/scripts`, `interval_list_to_pseq_reg` command will be used.<br />
3. PLINK/SEQ serial commandlines : download and install from http://atgu.mgh.harvard.edu/plinkseq/download.shtml. Please download the Core resource databases (hg19) by this website.<br />
4. Building the resource databases : GTFs from the UCSC table browser were downloaded for hg19, for RefSeq, CCDS and GENCODE transcripts. for example, download the `refseq-hg19.gtf.gz` from the UCSC Table Brower https://genome.ucsc.edu/cgi-bin/hgTables. <br />
Example : Here is an example of a simple query that retrieves all the RefSeq Genes records in the position range chr7:26906938-26940301 on the May 2004 human genome assembly.The Table Browser will display the records for the RefSeq accessions NM_005522, NM_153620, NM_006735, NM_153632, NM_030661, and NM_153631.  
  a. Select the Human option in the genome list.  
  b. Select the May 2004 option in the assembly list.  
  c. Select the Genes and Gene Prediction Tracks option in the group list  
  d. Select the RefSeq Genes option in the track list.  
  e. Type chr7:26906938-26940301 in the position box (the Table Browser will automatically select the position option button).  
  f. Click the Get Output button.  
  $ pseq . loc-load --file refseq-hg19.gtf.gz --group refseq --locdb locdb <br />

## **workflow**  
**PART I** : Run GATK depth of coverage to get sequencing depths --> combine GATK depth of converage outputs
**PART II** : please see `main.sh`. 

## **Tips**
You can consult the XHMM standard workflow at its homeage. Or consult the whole procedure from ref.[4] 


## **Reference** <br />
1.	Fromer M, Moran JL, Chambert K, et al. Discovery and statistical genotyping of copy-number variation from whole-exome sequencing depth. Am J Hum Genet. Oct 5 2012;91(4):597-607. <br />
2.	Li H, Durbin R. Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics. Jul 15 2009;25(14):1754-1760.<br />
3.	McKenna A, Hanna M, Banks E, et al. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res. Sep 2010;20(9):1297-130.<br />
4.  Menachem Fromer and Shaun M. Purcell. Using XHMM software to detect copy number variation in whole-exome sequencing data. In Current Protocols in Human Genetics. John Wiley and Sons, Inc., 2014.<br />
