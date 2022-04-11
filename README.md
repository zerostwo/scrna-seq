# Snakemake workflow: scrna-seq

[![Snakemake][snakemake-badge]](snakemake-url)
[中文说明][zh-readme-url]

[snakemake-badge]: https://img.shields.io/badge/snakemake-≥6.13.2-brightgreen.svg
[snakemake-url]: https://snakemake.github.io
[zh-readme-url]: README-zh.md

A Snakemake workflow for single-cell RNA-seq analysis

## Authors

* Songqi Duan, https://songqi.online

## Usage

#### Step 1: Obtain a copy of this workflow

```bash
git clone https://github.com/zerostwo/scrna-seq.git
```

#### Step 2: Configure workflow

Configure the workflow according to your needs via editing the file `config.yaml`.

```yaml
#### Required ----
# Absolute path to Seurat object (RDS format)
INPUT: /home/duansq/pipeline/scrna-seq/resources/test_data.rds
# Grouping information, ensure that the grouping field exists in the meta.data of the Seurat object, and only contains two groups
GROUP: METTL3_group
# Set the treatment group in the grouping field
TREATMENT: positive
# Set Assay
ASSAY: RNA
# Set species
SPECIES: Homo sapiens

#### Optional ----
# ...
```

#### Step 3: Execute workflow

Test your configuration by performing a dry-run via

```bash
snakemake -np
```
Execute the workflow locally via

```bash
snakemake --cores 20
```