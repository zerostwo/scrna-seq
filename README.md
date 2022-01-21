# Snakemake workflow: scrna-seq

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.13.2-brightgreen.svg)](https://snakemake.github.io)

A Snakemake workflow for single-cell RNA-seq analysis

## 输入数据格式
最初输入对象：seurat.obj，meta.data应该至少包括group（二分类）和cell_type
全局config参数
SAMPLES = {"colon_immune"}
GROUP = "METTL3_group"

## 分析模块
1. 差异分析（每个cell_type按照group做差异分析）：
    输入文件./resources/{sample}.rds
    输出文件./results/{sample}/deg/deg.csv
2. 功能分析（包括每个细胞类型的GO，KEGG，GSVA，GSEA）
    输入文件./results/{sample}/deg/deg.csv
    输出文件./resutls/{sample}/function/go.csv
3. 细胞通讯：
	输入文件./resources/{sample}.rds
	输出文件夹./results/{sample}/cellchat/	
4. scenic转录因子预测：
	输入文件./resources/{sample}.rds
	输出文件夹./results/{sample}/scenic/

## 使用方法
### R语言部分
```R
#### 导入R包 ----
library(Seurat)
#### 导入数据 ----
seurat.obj <- readRDS("./output/01_seurat/PAAD_seurat.rds")
#### 提取细胞类型 ----
sub.seurat.obj <- subset(seurat.obj, subset=cell_type=="Ductal cells 2")
#### 保存数据 ----
saveRDS(sub.seurat.obj, "./output/01_seurat/ep.rds")
```

### Linux命令行部分
新建一个config.yaml文件
```yaml
SAMPLES: {
  "dc2"
}
FEATURE: "IGF2BP2"
GROUP: "group"
TREATMENT: "Tumor"
```

运行snakemake程序
```bash
# 1. 切换到pipeline路径
cd /DATA/pipeline/scrna
# 2. 激活snakemake环境
conda activate snakemake
# 3. 建立rds文件软链接到/DATA/pipeline/scrna/resources
ln -s /home/duansq/projects/scrna-m6A/output/01_seurat/dc2.rds /DATA/pipeline/scrna/resources
# 4. 试运行（未报错再运行下面第5步）
snakemake -np --configfile /home/duansq/projects/scrna-m6A/code/dc2.yaml
# 5. 正式运行
snakemake --cores 20 --configfile /home/duansq/projects/scrna-m6A/code/dc2.yaml
```