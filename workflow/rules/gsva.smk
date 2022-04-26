# GSVA打分
rule GSVA_HALLMARK:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/{SCORE_METHOD}/hallmark.{SCORE_METHOD}.rds"
    log:
        "results/{sample}/logs/hallmark.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/hallmark.{SCORE_METHOD}.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c H -a {ASSAY} -s "{SPECIES}" -m {SCORE_METHOD} > {log} 2>&1
        """
rule GSVA_C2:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/{SCORE_METHOD}/c2.{SCORE_METHOD}.rds"
    log:
        "results/{sample}/logs/c2.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/c2.{SCORE_METHOD}.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C2 -a {ASSAY} -s "{SPECIES}" -m {SCORE_METHOD} > {log} 2>&1
        """

rule GSVA_C5:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/{SCORE_METHOD}/c5.{SCORE_METHOD}.rds"
    log:
        "results/{sample}/logs/c5.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/c5.{SCORE_METHOD}.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C5 -a {ASSAY} -s "{SPECIES}" -m {SCORE_METHOD} > {log} 2>&1
        """
rule GSVA_C6:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/{SCORE_METHOD}/c6.{SCORE_METHOD}.rds"
    log:
        "results/{sample}/logs/c6.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/c6.{SCORE_METHOD}.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C6 -a {ASSAY} -s "{SPECIES}" -m {SCORE_METHOD} > {log} 2>&1
        """

rule GSVA_C7:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/score/{SCORE_METHOD}/c7.{SCORE_METHOD}.rds"
    log:
        "results/{sample}/logs/c7.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/c7.{SCORE_METHOD}.benchmark.txt"
    threads: workflow.cores / 10
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -c C7 -a {ASSAY} -s "{SPECIES}" -m {SCORE_METHOD} > {log} 2>&1
        """
# 差异分析
rule GSVA_HALLMARK_DIFF:
    input:
        "results/{sample}/score/{SCORE_METHOD}/hallmark.{SCORE_METHOD}.rds"
    output:
        "results/{sample}/score/{SCORE_METHOD}/{GROUP}.hallmark.diff.{SCORE_METHOD}.csv"
    log:
        "results/{sample}/logs/{GROUP}.hallmark.diff.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.hallmark.diff.{SCORE_METHOD}.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C2_DIFF:
    input:
        "results/{sample}/score/{SCORE_METHOD}/c2.{SCORE_METHOD}.rds"
    output:
        "results/{sample}/score/{SCORE_METHOD}/{GROUP}.c2.diff.{SCORE_METHOD}.csv"
    log:
        "results/{sample}/logs/{GROUP}.c2.diff.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c2.diff.{SCORE_METHOD}.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C5_DIFF:
    input:
        "results/{sample}/score/{SCORE_METHOD}/c5.{SCORE_METHOD}.rds"
    output:
        "results/{sample}/score/{SCORE_METHOD}/{GROUP}.c5.diff.{SCORE_METHOD}.csv"
    log:
        "results/{sample}/logs/{GROUP}.c5.diff.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c5.diff.{SCORE_METHOD}.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C6_DIFF:
    input:
        "results/{sample}/score/{SCORE_METHOD}/c6.{SCORE_METHOD}.rds"
    output:
        "results/{sample}/score/{SCORE_METHOD}/{GROUP}.c6.diff.{SCORE_METHOD}.csv"
    log:
        "results/{sample}/logs/{GROUP}.c6.diff.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c6.diff.{SCORE_METHOD}.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """
rule GSVA_C7_DIFF:
    input:
        "results/{sample}/score/{SCORE_METHOD}/c7.{SCORE_METHOD}.rds"
    output:
        "results/{sample}/score/{SCORE_METHOD}/{GROUP}.c7.diff.{SCORE_METHOD}.csv"
    log:
        "results/{sample}/logs/{GROUP}.c7.diff.{SCORE_METHOD}.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c7.diff.{SCORE_METHOD}.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/def.R -i {SEURAT_OBJ_PATH} -e {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """