#

## set up the dicretory (not file) which contains all .bam, .bai files.
dirPath <- './path/to/bam/direcotry'
bedFile <- './data/EXOME.interval_list.bed'
chr <- 22
output <- 'CODEX_results.txt'




## Create initial object to prepare anlaysis.
library(CODEX)
bamFile <- list.files(dirPath, pattern = '*.bam$')
bamdir <- file.path(dirPath, bamFile)
head(bamdir)
sampname <- as.matrix(paste0("sample", 1:length(bamFile)))

bambedObj <- getbambed(bamdir = bamdir, bedFile = bedFile, 
                       sampname = sampname, projectname = "CODEX", chr)



## calculate coverage
coverageObj <- getcoverage(bambedObj, mapqthres = 20)
Y <- coverageObj$Y


## quality controls
gc <- getgc(chr, ref)
mapp <- getmapp(chr, ref)
qcObj <- qc(Y, sampname, chr, ref, mapp, gc, cov_thresh = c(20, 4000), 
    length_thresh = c(20, 2000), mapp_thresh = 0.9, gc_thresh = c(20, 80))



## normalization
normObj <- normalize(qcObj$Y_qc, qcObj$gc_qc, K = 1:9)
Yhat <- normObj$Yhat
AIC <- normObj$AIC
BIC <- normObj$BIC
RSS <- normObj$RSS
K <- normObj$K
Kmax <- length(AIC)
par(mfrow = c(1, 3))
plot(K, RSS, type = "b", xlab = "Number of latent variables")
plot(K, AIC, type = "b", xlab = "Number of latent variables")
plot(K, BIC, type = "b", xlab = "Number of latent variables")


### if data contains control samples, use this approach.
### set ID of control samples into normal_index 
###
## normObj <- normalize2(Y_qc, gc_qc, K = 1:9, normal_index=seq(1,45,2))
## Yhat <- normObj$Yhat
## AIC <- normObj$AIC
## BIC <- normObj$BIC
## RSS <- normObj$RSS
## K <- normObj$K



## set optimized K and call CNVs
optK = K[which.max(BIC)]
finalcall <- segment(qcObj$Y_qc, Yhat, optK = optK, K = K, qcObj$sampname_qc,
    qcObj$ref_qc, chr, lmax = 200, mode = "integer")
finalcall


## save the results.
write.table(finalcall, file = output, sep='\t', quote=FALSE, row.names=FALSE)




