#!/usr/bin/env Rscript

# Note: need to change nextflow variables to local R variables
# Last modified: tis nov 30, 2021  03:59
# Sign: JN

library("ggplot2")
library("ggrepel")

bamfile = "bam.list" #"${name}"
subset = "bam" # "${subset}#

bam_list <- read.table("${name}", header=FALSE)

pop <- data.frame(indiv=character(0))
for (i in 1:length(bam_list[["V1"]])) {
    line <- strsplit(bam_list[i,], split = '/')
    name <- rev(unlist(line))[2]
    pop[i,] <- name
}
pop <- unlist(list(pop[["indiv"]]))
C <- as.matrix(read.table("${subset}.cov"))
e <- as.data.frame(eigen(C)[["vectors"]])
p = ggplot(aes_(x=e[["V1"]], y=e[["V2"]]), data=e) +
    geom_point() +
    theme_classic() +
    ggtitle("${subset}") +
    xlab("PC1") +
    ylab("PC2") +
    geom_label_repel(
        aes_(x=e[["V1"]], y=e[["V2"]], label=pop),
        point.padding=0.1, label.size=0.1, box.padding=0.35,
        label.padding=0.1, show.legend=FALSE, size=4,
        min.segment.length=0.1, max.overlaps=100)
plot(p)
ggsave(
    "${subset}_PCA.pdf",
    plot=last_plot(),
    device="pdf",
    scale=1,
    width=15,
    height=15,
    unit="in")

