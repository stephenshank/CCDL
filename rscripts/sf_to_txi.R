library(tximport)
library(EnsDb.Hsapiens.v86)


args <- commandArgs(trailingOnly=TRUE)

file_in = args[1]
file_raw = args[2]
file_LSTPM = args[3]
file_STPM = args[4]
file_DSTPM = args[5]


#print(file_in)
#print(file_raw)
#print(file_LSTPM)
#print(file_STPM)
#print(file_DSTPM)


sample <- file.path(file_in)
txdf <- transcripts(EnsDb.Hsapiens.v86, return.type="DataFrame")
tx2gene <- as.data.frame(txdf[,c("tx_id", "gene_id")])

Raw_txi <- tximport(sample, type="salmon", tx2gene=tx2gene, ignoreTxVersion = TRUE)
LSTPM_txi <- tximport(sample, type="salmon", tx2gene=tx2gene, ignoreTxVersion = TRUE, countsFromAbundance = 'lengthScaledTPM')
STPM_txi <- tximport(sample, type="salmon", tx2gene=tx2gene, ignoreTxVersion = TRUE, countsFromAbundance = 'scaledTPM')
#DSTPM_txi <- tximport(sample, type="salmon", tx2gene=tx2gene, ignoreTxVersion = TRUE, countsFromAbundance = 'dtuScaledTPM', txOut = TRUE)


write.csv(as.data.frame(Raw_txi), file = file_raw)
write.csv(as.data.frame(LSTPM_txi), file = file_LSTPM)
write.csv(as.data.frame(STPM_txi), file = file_STPM)
#write.csv(as.data.frame(DSTPM_txi),file = file_DSTPM)





