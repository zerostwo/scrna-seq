## 输入数据格式
输入对象：{sample}.obj，meta.data应该至少包括group（二分类）和cell_type

## 分析模块
1. 差异基因富集分析
  输入文件：./resources/{sample}.rds
  输出文件./resutls/{sample}/function/go.csv
2. GSEA与GSVA分析
  输入文件：./results/
3. 转录因子分析
	输入文件：./resources/{sample}.rds
	输出路径：./results/{sample}/scenic/

## 使用方法
### 配置程序
```bash
cd ~/
git clone https://github.com/zerostwo/scrna-seq.git
mkdir ~/scrna-seq/resources
```
### R语言部分
```R
#### 导入R包 ----
library(Seurat)
#### 导入数据 ----
seurat.obj <- readRDS("./output/01_seurat/PAAD_seurat.rds")
#### 提取细胞类型 ----
sub.seurat.obj <- subset(seurat.obj, subset=cell_type=="Ductal cells 2")
#### 保存数据 ----
saveRDS(sub.seurat.obj, "./output/01_seurat/test_data.rds")
```

### Linux命令行部分
直接到`~/scrna-seq/config/config.yaml`路径下修改`config.yaml`文件。
注意**SAMPLES**内的字符需要和上一步保存的rds文件名一致。
```yaml
#### 必须填写的内容 ----
# 从R语言里面保存的Seurat对象路径
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

运行snakemake程序
```bash
# 1. 切换到pipeline路径
cd ~/scrna-seq
# 2. 激活snakemake环境
conda activate snakemake
# 3. 建立rds文件软链接到~/scrna-seq/resources
ln -s /home/duansq/pipeline/scrna-seq/resources/test_data.rds ~/scrna-seq/resources
# 4. 试运行（未报错再运行下面第5步）
snakemake -np
# 5. 正式运行
snakemake --cores 20
```