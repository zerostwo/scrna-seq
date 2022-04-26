#### Information ----
# Title   :
# File    :   function_GSEA.R
# Author  :   Songqi Duan
# Contact :   songqi.duan@outlook.com
# License :   Copyright (C) 2014-2022 by Songqi Duan
# Created :   2021/12/13 17:09:13
# Updated :   2022/02/21 16:45:11

#### 导入包 ----
library(msigdbr)
library(clusterProfiler)
library(tidyverse)
library(optparse)

option_list <- list(
  make_option(
    c("-i", "--input"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "DEGs csv path"
  ),
  make_option(
    c("-o", "--output"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Output Path"
  ),
  make_option(
    c("-c", "--category"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "MSigDB"
  ),
  make_option(
    c("-s", "--species"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Species, you can set Homo sapiens or Mus musculus"
  )
)
opt <- parse_args(OptionParser(
  option_list = option_list,
  usage = "This Script is a test for arguments!"
))
print(opt)

#### 导入数据 ----
deg <-
  read_csv(opt$input)
cell.types <- names(table(deg$cell_type))
#### GSEA分析 ----
# 设置基因集
# H, C2, C5, C6, C7
# H: hallmark gene sets  are coherently expressed signatures derived by aggregating many MSigDB gene sets to represent well-defined biological states or processes.
# C2: curated gene sets  from online pathway databases, publications in PubMed, and knnowledge of domain experts.
# C5: ontology gene sets  consist of genes annotated by the same ontology term.
# C6: oncogenic signature gene sets  defined directly from microarray gene expression data from cancer gene perturbations.
# C7: immunologic signature gene sets  represent cell states and perturbations within the immune system.
category <- opt$category
genesets <- msigdbr::msigdbr(
  species = opt$species,
  category = category
) %>%
  dplyr::select(gs_name, gene_symbol)

res <- list()
for (cell.type in cell.types) {
  print(cell.type)
  # cell.type <- cell.types[1]
  filtered.deg <- deg %>%
    filter(cell_type == cell.type) %>%
    as.data.frame()

  rownames(filtered.deg) <- filtered.deg$gene
  filtered.deg <-
    filtered.deg[order(filtered.deg$avg_log2FC, decreasing = T), ]
  genelist <-
    structure(filtered.deg$avg_log2FC, names = rownames(filtered.deg))
  genelist <- genelist[genelist != 0]
  tmp.res <- clusterProfiler::GSEA(
    genelist,
    TERM2GENE = genesets,
    # eps = 0,
    pvalueCutoff = 1,
    seed = 717
  )
  # result <- tryCatch(
  #   {
  #     tmp.res <- clusterProfiler::GSEA(
  #       genelist,
  #       TERM2GENE = genesets,
  #       # eps = 0,
  #       # pvalueCutoff = 1,
  #       seed = 717
  #     )
  #   },
  #   warning = function(w) {
  #     "W"
  #   },
  #   error = function(e) {
  #     "E"
  #   }
  # )
  # result
  # if (result != "E") {
  #   tmp.res <- clusterProfiler::GSEA(
  #     genelist,
  #     TERM2GENE = genesets,
  #     eps = 0,
  #     pvalueCutoff = 1,
  #     seed = 717
  #   )
  res[[cell.type]] <- tmp.res
}
saveRDS(res, opt$output)
