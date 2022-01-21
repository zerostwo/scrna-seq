#### Information ----
# Title   :   
# File    :   cor_function.R
# Author  :   Songqi Duan
# Contact :   songqi.duan@outlook.com
# License :   Copyright (C) 2014-2021 by Songqi Duan
# Created :   2021/12/13 19:16:09
# Updated :   none

library(Seurat)
library(tidyverse)
library(optparse)

option_list <- list(
    make_option(c("-i", "--input"),
        type = "character", default = FALSE,
        action = "store", help = "Seurat Object"
    ),
    make_option(c("-o", "--output"),
        type = "character", default = FALSE,
        action = "store", help = "Output Path"
    ),
    make_option(c("-p", "--prefix"),
        type = "character", default = FALSE,
        action = "store", help = "Group"
    ),
    make_option(c("-e", "--esmatrix"),
        type = "character", default = FALSE,
        action = "store", help = "es.matrix"
    ),
    make_option(c("-g", "--group"),
        type = "character", default = FALSE,
        action = "store", help = "Group"
    ),
    make_option(c("-f", "--feature"),
        type = "character", default = FALSE,
        action = "store", help = "Feature"
    )
)
opt <- parse_args(OptionParser(
    option_list = option_list,
    usage = "This Script is a test for arguments!"
))
print(opt)

seurat.obj <- readRDS(opt$input)
es.matrix <-
  readRDS(opt$esmatrix)
seurat.obj <-
  AddMetaData(seurat.obj,
              metadata = t(es.matrix),
              col.name = rownames(es.matrix))
seurat.obj$feature_data <-
  GetAssayData(seurat.obj, slot = "data")[opt$feature, ]

selected.group <- opt$group # 设定分组
groups <- names(table(seurat.obj@meta.data[, selected.group]))
seurat.obj$tmp_group <- seurat.obj@meta.data[, selected.group]
res <- data.frame()
for (Group in groups) {
  # Group <- groups[1]
  sub.seurat.obj <- subset(seurat.obj, subset = tmp_group == Group)
  meta.data <- sub.seurat.obj@meta.data

  features <- grep(paste0("^", opt$prefix, "_"), colnames(meta.data), value = T)
  tmp.res <- data.frame()
  for (feature in features) {
    # feature <- features[3]
    cor.test.res <-
      cor.test(meta.data[, "feature_data"],
               meta.data[, feature],
               method = "spearman",
               exact = F)
    p.value <- cor.test.res$p.value
    estimate <- cor.test.res$estimate
    tmp.res <- rbind(tmp.res, c(feature, p.value, estimate))
  }
  colnames(tmp.res) <- c("feature", "p_value", "estimate")
  tmp.res$group <- Group
  res <- rbind(res, tmp.res)
}

write.csv(res,
          opt$output,
          row.names = F,
          quote = T)