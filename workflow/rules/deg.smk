rule deg:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/deg/{GROUP}.{TEST_METHOD}.deg.csv"
    log:
        "results/{sample}/logs/{GROUP}.{TEST_METHOD}.deg.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.{TEST_METHOD}.deg.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/deg.R -i {input} -o {output} -g {GROUP} -t {TREATMENT} -a {ASSAY} -m {TEST_METHOD} > {log} 2>&1
        """