# GSVA打分
rule GSVA_HALLMARK:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/function/GSVA/{GROUP}.hallmark.gsva.rds"
    log:
        "results/{sample}/logs/{GROUP}.hallmark.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.hallmark.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {HALLMAKR_PATH} -a {ASSAY} > {log} 2>&1
        """
rule GSVA_C2:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/function/GSVA/{GROUP}.c2.gsva.rds"
    log:
        "results/{sample}/logs/{GROUP}.c2.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c2.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {C2_PATH} -a {ASSAY} > {log} 2>&1
        """

rule GSVA_C5:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/function/GSVA/{GROUP}.c5.gsva.rds"
    log:
        "results/{sample}/logs/{GROUP}.c5.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c5.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {C5_PATH} -a {ASSAY} > {log} 2>&1
        """
rule GSVA_C6:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/function/GSVA/{GROUP}.c6.gsva.rds"
    log:
        "results/{sample}/logs/{GROUP}.c6.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c6.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {C6_PATH} -a {ASSAY} > {log} 2>&1
        """

rule GSVA_C7:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/function/GSVA/{GROUP}.c7.gsva.rds"
    log:
        "results/{sample}/logs/{GROUP}.c7.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c7.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {C7_PATH} -a {ASSAY} > {log} 2>&1
        """