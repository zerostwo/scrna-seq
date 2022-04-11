# 转录调控网络分析
## 1. seurat对象转counts
rule seurat2loom:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/scenic/{GROUP}/expr_mat.loom"  
    log:
        "results/{sample}/logs/{GROUP}.seurat2loom.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.seurat2loom.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/seurat2loom.R -i {input} -o {output} > {log} 2>&1
        """
## 2. grn
rule grn:
    input:
        "results/{sample}/scenic/{GROUP}/expr_mat.loom"
    output:
        "results/{sample}/scenic/{GROUP}/expr_mat.adjacencies.tsv"
    log:
        "results/{sample}/logs/{GROUP}.grn.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.grn.benchmark.txt"
    threads: workflow.cores / 2
    shell:
        """
        {PYSCENIC_PATH} grn \
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
        "results/{sample}/scenic/{GROUP}/expr_mat.loom"
    output:
        "results/{sample}/scenic/{GROUP}/regulons.csv"
    log:
        "results/{sample}/logs/{GROUP}.ctx.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.ctx.benchmark.txt"
    threads: workflow.cores / 2
    shell:
        """
        {PYSCENIC_PATH} ctx \
            {input[0]} \
            {DATABASE_FILE_PATH} \
            --annotations_fname {ANNOTATIONS_FILE_PATH} \
            --expression_mtx_fname {input[1]} \
            --mode "dask_multiprocessing" \
            --output {output} \
            --num_workers {threads} > {log} 2>&1
        """
## 4. grn
rule aucell:
    input:
        "results/{sample}/scenic/{GROUP}/expr_mat.loom",
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
        {PYSCENIC_PATH} aucell \
            {input[0]} \
            {input[1]} \
            -o {output} \
            --num_workers {threads} > {log} 2>&1
        """