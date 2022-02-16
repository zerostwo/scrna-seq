#### 加载包 ----
library(Seurat)
library(GSVA)
library(GSEABase)
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
    make_option(c("-a", "--assay"),
        type = "character", default = FALSE,
        action = "store", help = "Assay"
    )
)
opt <- parse_args(OptionParser(option_list = option_list,
                               usage = "This Script is a test for arguments!"))
print(opt)
#### 导入数据 ----
# 读取基因集数据库
s.sets <- getGmt(opt$msigdb)

seurat.obj <-
  readRDS(opt$input) # 修改输入路径

expr <-
  as.matrix(GetAssayData(seurat.obj, assay = opt$assay, slot = "data"))
es.matrix <- gsva(
  expr,
  s.sets,
  kcdf = "Gaussian",
  method = "gsva",
  min.sz = 10,
  verbose = TRUE,
  tau = 1,
  parallel.sz = 1
)

saveRDS(es.matrix,
        opt$output)