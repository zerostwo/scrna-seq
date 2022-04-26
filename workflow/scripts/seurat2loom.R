#### Information ----
# Title   :   Seurat object is transformed into expression matrix
# File    :   seurat2count.R
# Author  :   Songqi Duan
# Contact :   songqi.duan@outlook.com
# License :   Copyright (C) 2017-2021 by Songqi Duan | 段松岐
# Created :   2021/03/07 15:40:10
# Updated :   2021/05/25 23:07:17

#### Load package ----
pacman::p_load(Seurat)
pacman::p_load(SeuratDisk)
pacman::p_load(tidyverse)

#### Parameter configuration -----
pacman::p_load(optparse)
option_list <- list(
  make_option(c("-i", "--input"),
    type = "character", default = FALSE,
    action = "store", help = "Seurat Object"
  ),
  make_option(c("-c", "--celltype"),
    type = "character", default = FALSE,
    action = "store", help = "Seurat Object"
  ),
  make_option(c("-o", "--output"),
    type = "character", default = FALSE,
    action = "store", help = "Output Path"
  )
)
opt <- parse_args(OptionParser(
  option_list = option_list,
  usage = "This Script is a test for arguments!"
))
print(opt)

#### Load data ----
seurat_obj <- readRDS(opt$input)
cell_types <- names(table(seurat_obj$cell_type))

#### Data processing ----
sub_seurat_obj <-
  subset(seurat_obj, subset = cell_type == gsub("____", " ", opt$celltype))
sub_seurat_obj <- CreateSeuratObject(GetAssayData(sub_seurat_obj, assay = "RNA", slot = "counts"))
loom <- as.loom(sub_seurat_obj, filename = opt$output)
