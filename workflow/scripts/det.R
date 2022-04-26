pacman::p_load(Seurat)
pacman::p_load(tidyverse)
pacman::p_load(limma)
pacman::p_load(optparse)
#### Parameter configuration -----
option_list <- list(
  make_option(c("-i", "--input"),
    type = "character", default = FALSE,
    action = "store", help = "Seurat Object"
  ),
  make_option(c("-e", "--expr"),
    type = "character", default = FALSE,
    action = "store", help = "Expression matrix"
  ),
  make_option(c("-o", "--output"),
    type = "character", default = FALSE,
    action = "store", help = "Output Path"
  ),
  make_option(c("-g", "--group"),
    type = "character", default = FALSE,
    action = "store", help = "Group"
  ),
  make_option(c("-t", "--treatment"),
    type = "character", default = FALSE,
    action = "store", help = "Positive group"
  ),
  make_option(c("-c", "--celltype"),
    type = "character", default = FALSE,
    action = "store", help = "Cell type"
  )
)
opt <- parse_args(OptionParser(
  option_list = option_list,
  usage = "This Script is a test for arguments!"
))
print(opt)

seurat_obj <-
  readRDS(opt$input)
seurat_obj <- seurat_obj %>% subset(subset = cell_type == gsub("____", " ", opt$celltype))
metadata <- seurat_obj@meta.data

es_matrix <-
  read_csv(
    opt$expr
  )
es_matrix <- es_matrix %>%
  pivot_longer(-Cell) %>%
  pivot_wider(names_from = Cell, values_from = value) %>%
  column_to_rownames("name")

s_group <- opt$group
positive_group <- opt$treatment

metadata <- metadata %>% rename(tmp_group = s_group)

cell_types <- metadata %>%
  count(cell_type) %>%
  pull(cell_type)
res <- map(cell_types, function(x) {
  filtered_metadata <-
    metadata %>%
    filter(cell_type == x)
  filtered_es_matrix <-
    es_matrix[rownames(filtered_metadata)]
  groups <- metadata %>%
    count(tmp_group) %>%
    pull(1)
  positive_group <- groups[which(groups == positive_group)]
  negative_group <- groups[which(groups != positive_group)]
  if (identical(colnames(filtered_es_matrix), rownames(filtered_metadata))) {
    positive_cell_id <-
      filtered_metadata %>%
      filter(tmp_group == positive_group) %>%
      rownames()
    negative_cell_id <-
      filtered_metadata %>%
      filter(tmp_group == negative_group) %>%
      rownames()
    positive_es_matrix <-
      filtered_es_matrix %>%
      select(all_of(positive_cell_id))
    negative_es_matrix <-
      filtered_es_matrix %>%
      select(all_of(negative_cell_id))
    filtered_es_matrix <-
      cbind(positive_es_matrix, negative_es_matrix)
    # 分组设计
    group <-
      c(
        rep(positive_group, dim(positive_es_matrix)[2]),
        rep(negative_group, dim(negative_es_matrix)[2])
      ) %>% as.factor()
    design <- model.matrix(~ group + 0)
    rownames(design) <-
      c(
        colnames(positive_es_matrix),
        colnames(negative_es_matrix)
      )
    compare <-
      makeContrasts(
        contrasts = c(str_c(
          "group", positive_group, "-",
          "group", negative_group
        )),
        levels = design
      )
    fit <- lmFit(filtered_es_matrix, design)
    fit2 <- contrasts.fit(fit, compare)
    fit3 <- eBayes(fit2)
    diff <- topTable(fit3, coef = 1, number = 19990524)
    diff <- diff %>%
      mutate(cell_type = x) %>%
      rownames_to_column("feature")
    return(diff)
  }
})
def <- map_df(res, as_tibble)
write_csv(def, opt$output)
