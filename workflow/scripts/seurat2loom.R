#### Information ----
# Title   :   Seurat object is transformed into expression matrix
# File    :   seurat2count.R
# Author  :   Songqi Duan
# Contact :   songqi.duan@outlook.com
# License :   Copyright (C) 2017-2021 by Songqi Duan | 段松岐
# Created :   2021/03/07 15:40:10
# Updated :   2021/05/25 23:07:17

#### Load package ----
library(Seurat)
library(SeuratDisk)

#### Parameter configuration -----
library(optparse)
option_list <- list(
  make_option(c("-i", "--input"),
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
SEURAT_OBJ_PATH <- readRDS(opt$input)
SEURAT_OBJ_PATH <- CreateSeuratObject(GetAssayData(SEURAT_OBJ_PATH, assay = "RNA", slot = "counts"))
#### Data processing ----
loom <- as.loom(SEURAT_OBJ_PATH, filename = opt$output)
