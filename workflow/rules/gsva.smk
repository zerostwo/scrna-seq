# GSVA打分
rule GSVA_HALLMARK:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/GSVA/hallmark.gsva.rds"
    log:
        "results/{sample}/logs/hallmark.gsva.log"
    benchmark:
        "results/{sample}/benchmark/hallmark.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c H -a {ASSAY} -s "{SPECIES}" > {log} 2>&1
        """
rule GSVA_C2:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/GSVA/c2.gsva.rds"
    log:
        "results/{sample}/logs/c2.gsva.log"
    benchmark:
        "results/{sample}/benchmark/c2.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C2 -a {ASSAY} -s "{SPECIES}" > {log} 2>&1
        """

rule GSVA_C5:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/GSVA/c5.gsva.rds"
    log:
        "results/{sample}/logs/c5.gsva.log"
    benchmark:
        "results/{sample}/benchmark/c5.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C5 -a {ASSAY} -s "{SPECIES}" > {log} 2>&1
        """
rule GSVA_C6:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/GSVA/c6.gsva.rds"
    log:
        "results/{sample}/logs/c6.gsva.log"
    benchmark:
        "results/{sample}/benchmark/c6.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C6 -a {ASSAY} -s "{SPECIES}" > {log} 2>&1
        """

rule GSVA_C7:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/GSVA/c7.gsva.rds"
    log:
        "results/{sample}/logs/c7.gsva.log"
    benchmark:
        "results/{sample}/benchmark/c7.gsva.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C7 -a {ASSAY} -s "{SPECIES}" > {log} 2>&1
        """
# 差异分析
rule GSVA_HALLMARK_DIFF:
    input:
        "results/{sample}/score/GSVA/hallmark.gsva.rds"
    output:
        "results/{sample}/score/GSVA/{GROUP}.hallmark.diff.gsva.csv"
    log:
        "results/{sample}/logs/{GROUP}.hallmark.diff.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.hallmark.diff.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C2_DIFF:
    input:
        "results/{sample}/score/GSVA/c2.gsva.rds"
    output:
        "results/{sample}/score/GSVA/{GROUP}.c2.diff.gsva.csv"
    log:
        "results/{sample}/logs/{GROUP}.c2.diff.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c2.diff.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C5_DIFF:
    input:
        "results/{sample}/score/GSVA/c5.gsva.rds"
    output:
        "results/{sample}/score/GSVA/{GROUP}.c5.diff.gsva.csv"
    log:
        "results/{sample}/logs/{GROUP}.c5.diff.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c5.diff.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C6_DIFF:
    input:
        "results/{sample}/score/GSVA/c6.gsva.rds"
    output:
        "results/{sample}/score/GSVA/{GROUP}.c6.diff.gsva.csv"
    log:
        "results/{sample}/logs/{GROUP}.c6.diff.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c6.diff.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C7_DIFF:
    input:
        "results/{sample}/score/GSVA/c7.gsva.rds"
    output:
        "results/{sample}/score/GSVA/{GROUP}.c7.diff.gsva.csv"
    log:
        "results/{sample}/logs/{GROUP}.c7.diff.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c7.diff.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """