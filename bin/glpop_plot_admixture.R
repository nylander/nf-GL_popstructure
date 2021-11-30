#!/usr/bin/env Rscript

# Note: need to change nextflow variables to local R variables
# Last modified: tis nov 30, 2021  04:00
# Sign: JN

library("RColorBrewer")

bamfile = "bam.list" # "${name}"
subset = "bam" # "${subset}"
anc = 2 # "${anc}"

#bam_list <- read.table(bamfile, header = FALSE)

bam_list <- read.table("$name", header=FALSE)
pop <- data.frame(indiv=character(0))
for (i in 1:length(bam_list[["V1"]])) {
    line <- strsplit(bam_list[i,], split='/')
    name <- rev(unlist(line))[2]
    pop[i,] <- name
}
admix <- t(as.matrix(read.table("${subset}_k${anc}.qopt")))
K <- nrow(admix)
ord <- order(pop[,1])
plot_nam <- paste0("${subset}_NGSadmix_k", K, ".pdf")
colors <- brewer.pal(K, "Dark2")
pdf(plot_nam)
bar <- barplot(admix[,ord], col=colors, space=0, border=NA, ylab="Admixture proportion", cex.names=0.4)
axis(1, labels=pop[ord,1], at=bar, las=2, cex.axis=0.4)
dev.off()

