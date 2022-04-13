## 输入数据要求
输入数据为Seurat对象的rds文件，Seurat对象的meta.data中应包括细胞类型`cell_type`和分组信息（例如：`group`，其下包括两个分组，例如Normal和Tumor）。

## 分析模块
1. 差异分析
  差异分析模块包括`差异基因分析`、`差异基因GO和KEGG通路富集`以及`差异基因排序后的GSEA分析`。
  差异分析使用`Seurat`包；功能富集及GSEA使用`clusterProfiler`包。
  输入文件：./resources/{sample}.rds
  输出文件./resutls/{sample}/function/go.csv
2. 打分
  
  输入文件：./resources/{sample}.rds
  
3. 转录因子
	转录因子分析模块使用pyscenic进行
  输入文件：./resources/{sample}.rds
	输出路径：./results/{sample}/scenic/

## 使用方法
### 1. 下载程序
```bash
cd ~/
git clone https://github.com/zerostwo/scrna-seq.git
```
### 2. 配置文件
根据自己实际情况在`~/scrna-seq/config/`路径下修改`config.yaml`文件。

```yaml
#### 必须填写的内容 ----
# Seurat对象的绝对路径
INPUT: /home/duansq/pipeline/scrna-seq/resources/test_data.rds
# 分组信息，保证分组字段在Seurat对象的meta.data存在，并且只包含两组
GROUP: METTL3_group
# 设置分组里的试验组
TREATMENT: positive
# 设置Assay
ASSAY: RNA
# 设置物种（可选：Homo sapiens或者Mus musculus）
SPECIES: Homo sapiens
#### 软件设置 ----
# pyscenic路径
PYSCENIC_PATH: /opt/pySCENIC/0.11.2/bin/pyscenic
# pyscenic注释文件
ANNOTATIONS_FILE_PATH: /DATA/public/cisTarget_databases/human/motifs-v9-nr.hgnc-m0.001-o0.0.tbl 
# 基因组排序文件
DATABASE_FILE_PATH: 
  /DATA/public/cisTarget_databases/human/hg38__refseq-r80__10kb_up_and_down_tss.mc9nr.feather
  /DATA/public/cisTarget_databases/human/hg38__refseq-r80__500bp_up_and_100bp_down_tss.mc9nr.feather
#### 可以选择性更改 ---- 
# 阈值
P_VALUE: 0.05
LOG2FC: 0.25
```
### 3. 运行snakemake程序
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