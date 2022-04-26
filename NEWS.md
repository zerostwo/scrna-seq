# Version 1.1.0

## ✨New features

- Added other scoring methods (`AddModuleScore`, `AUCell`)

## 🛠️Major changes

- GSVA calculation results are saved separately
- pyscenic for each cell type

## 🔧Minor changes

- In the GO and KEGG functional enrichment results, adjust the column name "regulate" to "change", adjust "upregulated" to "Upregulated", and adjust "downregulated" to "Downregulated"
- In GSEA analysis, genes with `avg_log2FC` equal to 0 will be removed and not included in subsequent analysis
- Use `pacman::p_load()` instead of `library()` to load packages

## 🐛Bug fixs

- Fixed the error that no result was enriched when GO or KEGG function was enriched. If no pathway was enriched, it would return `NULL`
- Fixed the problem of conflict error reporting caused by the group column in the `metadata` during the analysis of differences between groups (20220426)

# Initial Release (1.0.0)

- First release version to github (20220413)