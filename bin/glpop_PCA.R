#!/usr/bin/env Rscript

# Plot PCA from the output of NGAngsd
# Usage: glpop_PCA.R output.cov pop.info
# Based on https://github.com/aersoares81/PCAngsd-PCA-Plots-in-R
# (Note that input order of pop.info file is switched in this version,
# compared to Andrés original)
# Last modified: lör mar 29, 2025  04:51
# Sign: JN

# ======= Change settings in this section ====================
legend_title <- "Location"
plot_title <- "Geography of samples"
name_of_simple_pca_plot_pdf <- "simple_pca_plot.pdf"
name_of_labeled_pca_plot_pdf <- "labeled_pca_plot.pdf"
plot_width <- 28
plot_height <- 24
point_size <- 8
palette <- "Set3" # Max 12 colors in this set
# ============================================================

args <- commandArgs(TRUE)
if (length(args) != 2 || any(grepl("-h|--help", args))) {
    cat("Usage: glpop_PCA.R input.cov pop.info\n")
    q("no")
}
input_cov <- args[1] # input_cov <- "input.cov"
pop_info <- args[2]  # pop_info <- "pop.info"


library <- function (...) {
   packages <- as.character(match.call(expand.dots = FALSE)[[2]])
   suppressWarnings(suppressMessages(lapply(packages, base::library, character.only = TRUE)))
   return(invisible())
}
library("RcppCNPy", "ggfortify", "tidyverse", "ggrepel", "RColorBrewer")


samplemat <- as.matrix(read.table(pop_info), header = FALSE)
if (ncol(samplemat) != 2) {
    cat("Error: pop.info file must have two columns!\n")
    q("no")
} else {
    cat("pop.info file read successfully!\n")
}

sampleheaders <- c("sample_id", "location")
colnames(samplemat) <- sampleheaders

cov_quad <- as.matrix(read.table(input_cov), header = FALSE)
if (ncol(cov_quad) != nrow(cov_quad)) {
    cat("Error: input.cov file must be square!\n")
    q("no")
} else {
    cat("input.cov file read successfully!\n")
}

run.pca <- eigen(cov_quad)
eigenvectors <- run.pca$vectors
pca.vectors <- as_tibble(cbind(samplemat, data.frame(eigenvectors)))

simple.pca <- ggplot(data = pca.vectors, aes(x = X1, y = X2, colour = location, label = sample_id)) +
    geom_point(size = point_size) +
    labs(title = plot_title, x = "PC1", y = "PC2") +
    theme(plot.title = element_text(face = "italic")) +
    scale_color_brewer(palette = palette)

labeled.pca <- ggplot(data = pca.vectors, aes(x = X1, y = X2, colour = location, label = sample_id)) +
    geom_point(size = point_size) +
    labs(title = plot_title, x = "PC1", y = "PC2") +
    theme(plot.title = element_text(face = "italic")) +
    geom_label_repel(show.legend = FALSE, max.overlaps = Inf) +
    scale_color_brewer(palette = palette)

ggsave(filename = name_of_simple_pca_plot_pdf,
    plot = simple.pca, width = plot_width, height = plot_height, units = "cm", dpi = 600)

ggsave(filename = name_of_labeled_pca_plot_pdf,
    plot = labeled.pca, width = plot_width, height = plot_height, units = "cm", dpi = 600)

if (file.exists(name_of_simple_pca_plot_pdf) && file.exists(name_of_labeled_pca_plot_pdf)) {
    cat("PCA plots created successfully!\n")
} else {
    cat("Error: PCA plots not created!\n")
}
