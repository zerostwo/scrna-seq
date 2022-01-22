rule GO:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/GO/{GROUP}.go.csv"
    log:
        "results/{sample}/logs/{GROUP}.go.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.go.benchmark.txt"
    threads: workflow.cores / 2
    shell:
        """
        Rscript workflow/scripts/function_GO.R -i {input} -o {output} -p 0.05 -f 0.25 > {log} 2>&1
        """

rule KEGG:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/KEGG/{GROUP}.kegg.csv"
    log:
        "results/{sample}/logs/{GROUP}.kegg.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.kegg.benchmark.txt"
    threads: workflow.cores / 2
    shell:
        """
        Rscript workflow/scripts/function_KEGG.R -i {input} -o {output} -p {P_VALUE} -f {LOG2FC} > {log} 2>&1
        """

rule GSEA_HALLMARK:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.hallmark.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.hallmark.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.hallmark.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c H > {log} 2>&1
        """
rule GSEA_C2:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c2.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c2.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c2.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C2 > {log} 2>&1
        """
rule GSEA_C5:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c5.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c5.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c5.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C5 > {log} 2>&1
        """
rule GSEA_C6:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c6.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c6.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c6.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C6 > {log} 2>&1
        """
rule GSEA_C7:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c7.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c7.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c7.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C7 > {log} 2>&1
        """