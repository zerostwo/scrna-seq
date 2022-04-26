pacman::p_load(Seurat)
pacman::p_load(optparse)

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
  )
)
opt <- parse_args(OptionParser(
  option_list = option_list,
  usage = "This Script is a test for arguments!"
))
print(opt)
seurat_obj <- readRDS(opt$input)
cell_types <- names(table(seurat_obj$cell_type))
cell_types <- gsub(" ", "____", cell_types)
write.table(
  cell_types,
  opt$output,
  quote = F,
  row.names = F,
  col.names = F
)
