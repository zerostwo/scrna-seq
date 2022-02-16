# 转录调控网络分析
## 1. seurat对象转counts
rule seurat2counts:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/scenic/{GROUP}/expr_mat.tsv"  
    log:
        "results/{sample}/logs/{GROUP}.seurat2counts.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.seurat2counts.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/seurat2count.R -i {input} -o {output} -a {ASSAY}> {log} 2>&1
        """
## 2. grn
rule grn:
    input:
        "results/{sample}/scenic/{GROUP}/expr_mat.tsv"
    output:
        "results/{sample}/scenic/{GROUP}/expr_mat.adjacencies.tsv"
    log:
        "results/{sample}/logs/{GROUP}.grn.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.grn.benchmark.txt"
    threads: workflow.cores / 2
    shell:
        """
        /opt/anaconda3/envs/pyscenic/bin/pyscenic grn \
            --num_workers {threads} \
            --seed 717 \
            -o {output} \
            {input} \
            /DATA/public/cisTarget_databases/resources/hs_hgnc_tfs.txt > {log} 2>&1
        """
## 3. ctx
rule ctx:
    input:
        "results/{sample}/scenic/{GROUP}/expr_mat.adjacencies.tsv",
        "results/{sample}/scenic/{GROUP}/expr_mat.tsv"
    output:
        "results/{sample}/scenic/{GROUP}/regulons.csv"
    log:
        "results/{sample}/logs/{GROUP}.ctx.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.ctx.benchmark.txt"
    threads: workflow.cores / 2
    shell:
        """
        /opt/anaconda3/envs/pyscenic/bin/pyscenic ctx \
            {input[0]} \
            /DATA/public/cisTarget_databases/human/hg19-500bp-upstream-7species.mc9nr.feather \
            /DATA/public/cisTarget_databases/human/hg19-tss-centered-10kb-7species.mc9nr.feather \
            --annotations_fname /DATA/public/cisTarget_databases/human/motifs-v9-nr.hgnc-m0.001-o0.0.tbl \
            --expression_mtx_fname {input[1]} \
            --mode "dask_multiprocessing" \
            --output {output} \
            --num_workers {threads} > {log} 2>&1
        """
## 4. grn
rule aucell:
    input:
        "results/{sample}/scenic/{GROUP}/expr_mat.tsv",
        "results/{sample}/scenic/{GROUP}/regulons.csv"
    output:
        "results/{sample}/scenic/{GROUP}/auc_mtx.csv"
    log:
        "results/{sample}/logs/{GROUP}.aucell.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.aucell.benchmark.txt"
    threads: workflow.cores / 2
    shell:
        """
        /opt/anaconda3/envs/pyscenic/bin/pyscenic aucell \
            {input[0]} \
            {input[1]} \
            -o {output} \
            --num_workers {threads} > {log} 2>&1
        """