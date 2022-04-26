rule GO:
    input:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    output:
        "results/{sample}/function/GO/{GROUP}.{TEST_METHOD}.go.csv",
    log:
        "results/{sample}/logs/{GROUP}.{TEST_METHOD}.go.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.{TEST_METHOD}.go.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/function_GO.R -i {input} -o {output} -p 0.05 -f 0.25 -s "{SPECIES}" > {log} 2>&1
        """

rule KEGG:
    input:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    output:
        "results/{sample}/function/KEGG/{GROUP}.{TEST_METHOD}.kegg.csv"
    log:
        "results/{sample}/logs/{GROUP}.{TEST_METHOD}.kegg.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.{TEST_METHOD}.kegg.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/function_KEGG.R -i {input} -o {output} -p {P_VALUE} -f {LOG2FC} -s "{SPECIES}" > {log} 2>&1
        """

rule GSEA_HALLMARK:
    input:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.hallmark.{TEST_METHOD}.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.hallmark.{TEST_METHOD}.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.hallmark.{TEST_METHOD}.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c H -s "{SPECIES}" > {log} 2>&1
        """
rule GSEA_C2:
    input:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c2.{TEST_METHOD}.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c2.{TEST_METHOD}.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c2.{TEST_METHOD}.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C2 -s "{SPECIES}" > {log} 2>&1
        """
rule GSEA_C5:
    input:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c5.{TEST_METHOD}.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c5.{TEST_METHOD}.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c5.{TEST_METHOD}.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C5 -s "{SPECIES}" > {log} 2>&1
        """
rule GSEA_C6:
    input:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c6.{TEST_METHOD}.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c6.{TEST_METHOD}.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c6.{TEST_METHOD}.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C6 -s "{SPECIES}" > {log} 2>&1
        """
rule GSEA_C7:
    input:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    output:
        "results/{sample}/function/GSEA/{GROUP}.c7.{TEST_METHOD}.gsea.rds"
    log:
        "results/{sample}/logs/{GROUP}.c7.{TEST_METHOD}.gsea.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.c7.{TEST_METHOD}.gsea.benchmark.txt"
    threads: workflow.cores / 5
    shell:
        """
        Rscript workflow/scripts/function_GSEA.R -i {input} -o {output} -c C7 -s "{SPECIES}" > {log} 2>&1
        """