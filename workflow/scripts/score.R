#### 加载包 ----
pacman::p_load(Seurat)
pacman::p_load(GSEABase)
pacman::p_load(tidyverse)
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
  ),
  make_option(
    c("-c", "--category"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "MSigDB"
  ),
  make_option(
    c("-a", "--assay"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Assay"
  ),
  make_option(
    c("-s", "--species"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Species, you can set Homo sapiens or Mus musculus"
  ),
  make_option(
    c("-m", "--method"),
    type = "character",
    default = FALSE,
    action = "store",
    help = "Score method, you can set GSVA, AddModuleScore"
  )
)

opt <- parse_args(OptionParser(
  option_list = option_list,
  usage = "This Script is a test for arguments!"
))
print(opt)
#### 导入数据 ----
seurat_obj <-
  readRDS(opt$input) # 修改输入路径
# 读取基因集数据库
genesets <- msigdbr::msigdbr(
  species = opt$species,
  category = opt$category
) %>%
  dplyr::select(gs_name, gene_symbol)
genesets <- genesets %>%
  filter(gene_symbol %in% rownames(seurat_obj))
s_sets <- split(genesets$gene_symbol, genesets$gs_name)

# GSVA score
run_gsva <- function(seurat_obj, cell_type, s_sets, assay) {
  pacman::p_load(GSVA)
  rds_output <- opt$output %>%
    str_replace(".rds", str_c(".", cell_type, ".rds"))
  if (!file.exists(rds_output)) {
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
    sub_es_matrix <- sub_es_matrix %>%
      as.data.frame()
    saveRDS(sub_es_matrix, rds_output)
  }
  if (file.exists(rds_output)) {
    sub_es_matrix <- readRDS(rds_output)
  }
  return(sub_es_matrix)
}
# AddModuleScore
run_addmodulescore <-
  function(seurat_obj, cell_type, s_sets, assay = "RNA") {
    rds_output <- opt$output %>%
      str_replace(".rds", str_c(".", cell_type, ".rds"))
    if (!file.exists(rds_output)) {
      selected_cell_type <- cell_type
      print(selected_cell_type)
      sub_seurat_obj <-
        subset(seurat_obj, subset = cell_type == selected_cell_type)
      sub_seurat_obj <-
        sub_seurat_obj %>% AddModuleScore(
          features = s_sets,
          name = str_c(names(s_sets), "__"),
          assay = assay,
          seed = 717
        )

      scores_matrix <- sub_seurat_obj@meta.data %>%
        rownames_to_column("cell_id") %>%
        select(
          "cell_id",
          str_c(names(s_sets), "__", seq_len(length(names(s_sets))))
        ) %>%
        pivot_longer(-cell_id) %>%
        pivot_wider(names_from = cell_id, values_from = value) %>%
        column_to_rownames("name")

      rownames(scores_matrix) <-
        str_split_fixed(rownames(scores_matrix), "__", 2)[, 1]
      saveRDS(scores_matrix, rds_output)
    }
    if (file.exists(rds_output)) {
      scores_matrix <- readRDS(rds_output)
    }
    return(scores_matrix)
  }
# AUCell
run_aucell <- function(seurat_obj, cell_type, s_sets, assay = "RNA") {
  rds_output <- opt$output %>%
    str_replace(".rds", str_c(".", cell_type, ".rds"))
  if (!file.exists(rds_output)) {
    selected_cell_type <- cell_type
    print(selected_cell_type)
    sub_seurat_obj <-
      subset(seurat_obj, subset = cell_type == selected_cell_type)
    exprMatrix <-
      as.matrix(GetAssayData(sub_seurat_obj, assay = assay, slot = "data"))
    cells_rankings <- AUCell_buildRankings(exprMatrix, nCores = 10)

    cells_AUC <-
      AUCell_calcAUC(s_sets, cells_rankings, aucMaxRank = nrow(cells_rankings) *
        0.05, nCores = 10)
    saveRDS(cells_AUC, rds_output)
  }
  if (file.exists(rds_output)) {
    cells_AUC <- readRDS(rds_output)
  }
  scores_matrix <- getAUC(cells_AUC)
  scores_matrix <- scores_matrix %>% as.data.frame()
  return(scores_matrix)
}

cell_types <- names(table(seurat_obj$cell_type))

method <- opt$method
if (method == "GSVA") {
  res <-
    map(
      cell_types,
      run_gsva,
      seurat_obj = seurat_obj,
      s_sets = s_sets,
      assay = opt$assay
    )
}
if (method == "AddModuleScore") {
  res <-
    map(
      cell_types,
      run_addmodulescore,
      seurat_obj = seurat_obj,
      s_sets = s_sets,
      assay = opt$assay
    )
}
if (method == "AUCell") {
  pacman::p_load(AUCell)
  res <-
    map(
      cell_types,
      run_aucell,
      seurat_obj = seurat_obj,
      s_sets = s_sets,
      assay = opt$assay
    )
}

names(res) <- cell_types
saveRDS(
  res,
  opt$output
)
