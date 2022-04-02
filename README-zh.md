## 输入数据格式
输入对象：{sample}.obj，meta.data应该至少包括group（二分类）和cell_type

## 分析模块
1. 差异基因富集分析
  输入文件：./resources/{sample}.rds
  输出文件./resutls/{sample}/function/go.csv
2. GSEA与GSVA分析
  输入文件：./results/
3. 

	输入文件：./resources/{sample}.rds
	输出路径：./results/{sample}/scenic/

## 使用方法
### 配置程序
```bash
cd ~/
git clone https://github.com.cnpmjs.org/zerostwo/scrna-seq.git
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
INPUT: /home/duansq/datasets/2022_adult-brain-vasc_EthanWinkler/data/am-endothelial/final_merged_ec_cb.rds
# 分组信息，保证分组字段在Seurat对象的meta.data存在，并且只包含两组
GROUP: group
# 设置分组里的试验组
TREATMENT: AVM
# 设置Assay
ASSAY: RNA
#### 可以选择性更改 ---- 
# 阈值
P_VALUE: 0.05
LOG2FC: 0.25
# MSigDB path
HALLMAKR_PATH: /DATA/public/MSigDB/h.all.v7.4.symbols.gmt
C2_PATH: /DATA/public/MSigDB/c2.all.v7.4.symbols.gmt
C5_PATH: /DATA/public/MSigDB/c5.all.v7.4.symbols.gmt
C6_PATH: /DATA/public/MSigDB/c6.all.v7.4.symbols.gmt
C7_PATH: /DATA/public/MSigDB/c7.all.v7.4.symbols.gmt
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