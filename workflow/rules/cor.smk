rule cor_cell_type:
    input:
        SEURAT_OBJ_PATH
    output:
        "results/{sample}/cor/{GROUP}.gene.cor.csv"
    log:
        "results/{sample}/logs/{GROUP}.gene.cor.log"
    shell:
        """
        Rscript workflow/scripts/cor_single_gene.R -i {input} -o {output} -g cell_type -f {FEATURE} > {log} 2>&1
        """
rule cor_hallmark:
    input:
        SEURAT_OBJ_PATH,
        "results/{sample}/function/GSVA/{GROUP}.hallmark.es.matrix.rds"
    output:
        "results/{sample}/cor/{GROUP}.hallmark.cor.csv"
    log:
        "results/{sample}/logs/{GROUP}.hallmark.cor.log"
    shell:
        """
        Rscript workflow/scripts/cor_function.R \
            -i {input[0]} -o {output} \
            -e  {input[1]} -p HALLMARK \
            -f {FEATURE} -g cell_type > {log} 2>&1
        """
rule cor_kegg:
    input:
        SEURAT_OBJ_PATH,
        "results/{sample}/function/GSVA/{GROUP}.kegg.es.matrix.rds"
    output:
        "results/{sample}/cor/{GROUP}.kegg.cor.csv"
    log:
        "results/{sample}/logs/{GROUP}.kegg.cor.log"
    shell:
        """
        Rscript workflow/scripts/cor_function.R \
            -i {input[0]} -o {output} \
            -e  {input[1]} -p KEGG \
            -f {FEATURE} -g cell_type > {log} 2>&1
        """

rule cor_gobp:
    input:
        SEURAT_OBJ_PATH,
        "results/{sample}/function/GSVA/{GROUP}.gobp.es.matrix.rds"
    output:
        "results/{sample}/cor/{GROUP}.gobp.cor.csv"
    log:
        "results/{sample}/logs/{GROUP}.gobp.cor.log"
    shell:
        """
        Rscript workflow/scripts/cor_function.R \
            -i {input[0]} -o {output} \
            -e  {input[1]} -p GOBP \
            -f {FEATURE} -g cell_type > {log} 2>&1
        """