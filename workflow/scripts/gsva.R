#### 加载包 ----
library(Seurat)
library(GSVA)
library(GSEABase)
library(tidyverse)
library(optparse)

#### 配置 ----
option_list <- list(
  make_option(
    c("-i", "--input"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Seurat object"
  ),
  make_option(
    c("-o", "--output"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Output file"
  ),
  make_option(
    c("-m", "--msigdb"),
    type = "character",
    default = NULL,
    action = "store",
    help = "MSigDB gmt file path"
  ),
  make_option(
    c("-a", "--assay"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Assay"
  )
)

opt <- parse_args(OptionParser(
  option_list = option_list,
  usage = "This Script is a test for arguments!"
))
print(opt)
#### 导入数据 ----
# 读取基因集数据库
s_sets <- getGmt(opt$msigdb)

seurat_obj <-
  readRDS(opt$input) # 修改输入路径

# expr <-
#   as.matrix(GetAssayData(seurat_obj, assay = opt$assay, slot = "data"))

run_gsva <- function(seurat_obj, cell_type, s_sets, assay) {
  selected_cell_type <- cell_type
  print(selected_cell_type)
  sub_seurat_obj <-
    subset(seurat_obj, subset = cell_type == selected_cell_type)
  sub_expr <-
    as.matrix(GetAssayData(sub_seurat_obj, assay = assay, slot = "data"))
  sub_es_matrix <- gsva(
    expr = sub_expr,
    gset.idx.list = s_sets
  )
  sub_es_matrix <- sub_es_matrix %>% as.data.frame()
  return(sub_es_matrix)
}

cell_types <- names(table(seurat_obj$cell_type))

res <-
  map(
    cell_types,
    run_gsva,
    seurat_obj = seurat_obj,
    s_sets = s_sets,
    assay = opt$assay
  )

# res <- res[, colnames(seurat_obj)]
names(res) <- cell_types
saveRDS(
  res,
  opt$output
)
