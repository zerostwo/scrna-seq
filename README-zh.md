# Snakemake流程: scrna-seq

[![Snakemake][snakemake-badge]](snakemake-url)
[English][en-readme-url]

[snakemake-badge]: https://img.shields.io/badge/snakemake-≥6.12.3-brightgreen.svg
[snakemake-url]: https://snakemake.github.io
[en-readme-url]: README.md

用于单细胞转录组分析的Snakemake工作流程

## 🤪 作者

* 段松岐, https://songqi.online

## 📦 分析模块
1. 差异分析
  该模块包括`差异基因分析`、`差异基因GO和KEGG通路富集`以及`差异基因排序后的GSEA分析`。
  差异分析使用`Seurat`包；功能富集及GSEA使用`clusterProfiler`包。
  输出路径：`./resutls/{sample}/deg/`和`./resutls/{sample}/function/`

2. 打分
  该模块下包括`GSVA`算法对[MSigDB](https://www.gsea-msigdb.org/gsea/msigdb/)数据库中H、C2、C5、C6和C7几个分类下的功能术语进行打分。
  打分使用`GSVA`包；差异分析使用`limma`包。
  输出路径：`./results/{sample}/score/`

3. 转录因子
  该模块下使用`pyscenic`进行转录因子预测，并使用`limma`包对组间转录因子做差异分析。
	输出路径：`./results/{sample}/scenic/`

## 🕹️ 使用方法

### 1. 输入数据要求
输入数据为Seurat对象的rds文件，Seurat对象的meta.data中应包括细胞类型`cell_type`和分组信息（例如：`group`，其下包括两个分组，例如Normal和Tumor）。

### 2. 下载程序
```bash
cd ~/
git clone https://github.com/zerostwo/scrna-seq.git
```
### 3. 配置文件
根据自己实际情况在`~/scrna-seq/config/`路径下修改`config.yaml`文件。

```yaml
#### 必须填写的内容 ----
# Seurat对象的绝对路径
INPUT: /home/duansq/pipeline/scrna-seq/resources/test_data.rds
# 分组信息，保证分组字段在Seurat对象的meta.data存在，并且只包含两组
GROUP: METTL3_group
# 设置分组里的试验组
TREATMENT: positive
# 差异检测方法（可选：MAST，bimod，wilcox，LR，t）
TEST_METHOD: wilcox
# 设置Assay
ASSAY: RNA
# 设置物种（可选：Homo sapiens或者Mus musculus）
SPECIES: Homo sapiens
# 打分方式（可选: GSVA，AddModuleScore或者AUCell）
SCORE_METHOD: AddModuleScore
#### 软件设置 ----
# pyscenic路径
PYSCENIC_PATH: /opt/pySCENIC/0.11.2/bin/pyscenic
# pyscenic注释文件
ANNOTATIONS_FILE_PATH: /DATA/public/cisTarget_databases/human/motifs-v9-nr.hgnc-m0.001-o0.0.tbl 
# 基因组排序文件
DATABASE_FILE_PATH: 
  /DATA/public/cisTarget_databases/human/hg38__refseq-r80__10kb_up_and_down_tss.mc9nr.feather
  /DATA/public/cisTarget_databases/human/hg38__refseq-r80__500bp_up_and_100bp_down_tss.mc9nr.feather
# 转录因子列表
TF_LIST: /DATA/public/cisTarget_databases/resources/hs_hgnc_tfs.txt
#### 可以选择性更改 ---- 
# 阈值
P_VALUE: 0.05
LOG2FC: 0.25
```
### 4. 运行snakemake程序
```bash
# 1. 切换到pipeline路径
cd ~/scrna-seq
# 2. 激活snakemake环境
conda activate snakemake
# 3. 试运行（未报错再运行下面第4步）
snakemake -np
# 4. 正式运行
snakemake --cores 10
```

## 📂 结果文件

程序完整运行后，会在`results`文件夹下生成结果。每个程序下通常会生成五个文件夹，结构如下：

```
test_data
├── benchmark
├── deg
├── function
│   ├── GO
│   ├── GSEA
│   └── KEGG
├── logs
├── scenic
└── score
```

- `benchmark`内包含了每个分析脚本运行消耗的CPU，内存及时间；
- `deg`内包含了差异基因分析的结果文件；
- `function`内包含三个子文件夹，分别是GO和KEGG富集分析以及GSEA的结果；
- `logs`内包含了每个分析脚本运行产生的日志文件；
- `scenic`内包含转录因子预测以及组间差异分析结果；
- `score`内包含一个子文件夹，为打分以及组件差异分析的结果。