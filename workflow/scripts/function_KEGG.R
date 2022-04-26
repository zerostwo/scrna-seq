#### Information ----
# Title   :   Enrich analysis of KEGG
# File    :   function_KEGG.R
# Author  :   Songqi Duan
# Contact :   songqi.duan@outlook.com
# License :   Copyright (C) 2014-2022 by Songqi Duan
# Created :   2021/12/13 16:15:21
# Updated :   2022/04/13 18:29:12
#### Load package ----
library(tidyverse)
library(optparse)
#### Parameter configuration -----
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
    c("-p", "--pvalue"),
    type = "double",
    default = FALSE,
    action = "store",
    help = "adjusted pvalue cutoff"
  ),
  make_option(
    c("-f", "--log2fc"),
    type = "double",
    default = FALSE,
    action = "store",
    help = "log2FC cutoff"
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
#### Load data ----
deg <-
  read_csv(opt$input)
print(head(deg))
deg <- deg %>%
  filter(p_val <= opt$pvalue)
cell.types <- names(table(deg$cell_type))
#### Enrich KEGG ----
enrich_go <- function(features, species) {
  if (species %in% c("human", "Homo sapiens")) {
    convert <- clusterProfiler::bitr(
      features,
      fromType = "SYMBOL",
      toType = c("ENTREZID"),
      OrgDb = org.Hs.eg.db::org.Hs.eg.db
    )
    top.genes <- convert$ENTREZID
    ego <- clusterProfiler::enrichKEGG(
      gene = top.genes,
      keyType = "kegg",
      organism = "hsa",
      pvalueCutoff = 0.05,
      pAdjustMethod = "BH",
      qvalueCutoff = 0.2,
    )
  }
  if (species %in% c("mouse", "Mus musculus")) {
    convert <- clusterProfiler::bitr(
      features,
      fromType = "SYMBOL",
      toType = c("ENTREZID"),
      OrgDb = org.Mm.eg.db::org.Mm.eg.db
    )
    top.genes <- convert$ENTREZID
    ego <- clusterProfiler::enrichKEGG(
      gene = top.genes,
      keyType = "kegg",
      organism = "mmu",
      pvalueCutoff = 0.05,
      pAdjustMethod = "BH",
      qvalueCutoff = 0.2,
    )
  }
  return(ego)
}
# Upregulated gene
upregulated_res <- map(cell.types, function(x) {
  print(x)
  upregulated_gene <- deg %>%
    filter(
      cell_type == x,
      avg_log2FC >= opt$log2fc
    ) %>%
    pull(gene)
  if (length(upregulated_gene) == 0) {
    return(NULL)
  }
  print(upregulated_gene)
  print(opt$species)
  bp <- enrich_go(upregulated_gene, opt$species)
})
names(upregulated_res) <- cell.types
upregulated_res_df <- map_df(cell.types, function(x) {
  if (!is.null(upregulated_res[[x]])) {
    upregulated.tmp.term <- upregulated_res[[x]]@result
    upregulated.tmp.term$cell_type <- x
    upregulated.tmp.term$change <- "Upregulated"
    return(upregulated.tmp.term)
  }
})
print("==== Downregulated ====")
# Downregulated gene
downregulated_res <- map(cell.types, function(x) {
  print(x)
  downregulated_gene <- deg %>%
    filter(
      cell_type == x,
      avg_log2FC <= -opt$log2fc
    ) %>%
    pull(gene)
  if (length(downregulated_gene) == 0) {
    return(NULL)
  }
  print(downregulated_gene)
  print(opt$species)
  bp <- enrich_go(downregulated_gene, opt$species)
})
names(downregulated_res) <- cell.types
downregulated_res_df <- map_df(cell.types, function(x) {
  if (!is.null(downregulated_res[[x]])) {
    downregulated.tmp.term <- downregulated_res[[x]]@result
    downregulated.tmp.term$cell_type <- x
    downregulated.tmp.term$change <- "Downregulated"
    return(downregulated.tmp.term)
  }
})
res_df <- upregulated_res_df %>% bind_rows(downregulated_res_df)
#### Save results ----
output <- opt$output
write_csv(res_df,
  file = output
)
# upregulated_res
upregulated_res_output <- output %>% str_replace(".csv", ".upregulated.rds")
saveRDS(upregulated_res, upregulated_res_output)
# downregulated_res
downregulated_res_output <- output %>% str_replace(".csv", ".downregulated.rds")
saveRDS(downregulated_res, downregulated_res_output)

#### test ----
# Rscript workflow/scripts/function_KEGG.R -i ./results/test_data/deg/METTL3_group.wilcox.deg.csv -o ./enrich_kegg.csv -p 0.05 -f 0.25 -s human
