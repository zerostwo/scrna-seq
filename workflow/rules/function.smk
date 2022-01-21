rule GO:
    input:
        "results/{sample}/deg/{GROUP}.deg.csv"
    output:
        "results/{sample}/function/GO/{GROUP}.go.csv"
    log:
        "results/{sample}/logs/{GROUP}.go.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.go.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/function_GO.R -i {input} -o {output} -p 0.05 -n 50 > {log} 2>&1
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
    shell:
        """
        Rscript workflow/scripts/function_KEGG.R -i {input} -o {output} -p 0.05 -n 50 > {log} 2>&1
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
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C5 > {log} 2>&1
        """