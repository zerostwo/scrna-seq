#### Information ----
# Title   :   
# File    :   function_KEGG.R
# Author  :   Songqi Duan
# Contact :   songqi.duan@outlook.com
# License :   Copyright (C) 2014-2021 by Songqi Duan
# Created :   2021/12/13 16:15:21
# Updated :   none

#### 导入包 ----
library(clusterProfiler)
library(org.Hs.eg.db) # 鼠：org.Mm.eg.db；人：org.Hs.eg.db
library(tidyverse)
library(optparse)

option_list <- list(
    make_option(c("-i", "--input"),
        type = "character", default = FALSE,
        action = "store", help = "DEGs csv path"
    ),
    make_option(c("-o", "--output"),
        type = "character", default = FALSE,
        action = "store", help = "Output Path"
    ),
    make_option(c("-p", "--pvalue"),
        type = "double", default = FALSE,
        action = "store", help = "pvalue cutoff"
    ),
    make_option(c("-n", "--number"),
        type = "integer", default = FALSE,
        action = "store", help = "gene number"
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
head(deg)
deg <- deg %>%
  filter(p_val <= opt$pvalue)
  
#### KEGG分析 ----
cell.types <- names(table(deg$cell_type))
term <- data.frame()
for (cell.type in cell.types) {
  # cell.type <- cell.types[1]
  # 上调基因GO
  upregulated.top.genes <- deg %>%
    filter(cell_type == cell.type) %>%
    arrange(desc(avg_log2FC)) %>%
    top_n(opt$number, wt = avg_log2FC)

  convert <- bitr(
    upregulated.top.genes$gene,
    fromType = "SYMBOL",
    toType = c("ENTREZID"),
    OrgDb = org.Hs.eg.db
  )
  top.genes <- convert$ENTREZID

  ego <- enrichKEGG(
    gene = top.genes,
    keyType = "kegg",
    organism  = 'hsa',
    # human: hsa, mouse: mmu
    pvalueCutoff  = 0.05,
    pAdjustMethod  = "BH",
    qvalueCutoff  = 0.2,
  )

  upregulated.tmp.term <- ego@result
  upregulated.tmp.term$celltype <- cell.type
  upregulated.tmp.term$regulated <- "upregulated"

  term <- rbind(term,
                upregulated.tmp.term)

  # 下调基因GO
  downregulated.top.genes <- deg %>%
    filter(cell_type == cell.type) %>%
    arrange(avg_log2FC) %>%
    top_n(opt$number, wt = -avg_log2FC)
  convert <- bitr(
    downregulated.top.genes$gene,
    fromType = "SYMBOL",
    toType = c("ENTREZID"),
    OrgDb = org.Hs.eg.db
  )
  top.genes <- convert$ENTREZID

  ego <- enrichKEGG(
    gene = top.genes,
    keyType = "kegg",
    organism  = 'hsa',
    # human: hsa, mouse: mmu
    pvalueCutoff  = 0.05,
    pAdjustMethod  = "BH",
    qvalueCutoff  = 0.2,
  )
  downregulated.tmp.term <- ego@result
  downregulated.tmp.term$celltype <- cell.type
  downregulated.tmp.term$regulated <- "downregulated"

  term <- rbind(term,
                downregulated.tmp.term)
}

write.csv(term,
          file = opt$output,
          row.names = F,
          quote = T)
