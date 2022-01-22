rule deg:
    input:
        SEURAT_OBJ
    output:
        "results/{sample}/deg/{GROUP}.deg.csv"
    log:
        "results/{sample}/logs/{GROUP}.deg.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.deg.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/deg.R -i {input} -o {output} -g {GROUP} -t {TREATMENT} > {log} 2>&1
        """