# # GSVA打分
# SAMPLES = {"colon_immune"}
# GROUP = "METTL3_group"
HALLMAKR_PATH = "/DATA/public/MSigDB/h.all.v7.4.symbols.gmt"
KEGG_PATH = "/DATA/public/MSigDB/c2.cp.kegg.v7.4.symbols.gmt"
GOBP_PATH = "/DATA/public/MSigDB/c5.go.bp.v7.4.symbols.gmt"

rule GSVA_HALLMARK:
    input:
        "resources/{sample}.rds"
    output:
        "results/{sample}/function/GSVA/{GROUP}.hallmark.es.matrix.rds"
    log:
        "results/{sample}/logs/{GROUP}.hallmark.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.hallmark.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {HALLMAKR_PATH} > {log} 2>&1
        """
rule GSVA_KEGG:
    input:
        "resources/{sample}.rds"
    output:
        "results/{sample}/function/GSVA/{GROUP}.kegg.es.matrix.rds"
    log:
        "results/{sample}/logs/{GROUP}.kegg.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.kegg.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {KEGG_PATH} > {log} 2>&1
        """

rule GSVA_GOBP:
    input:
        "resources/{sample}.rds"
    output:
        "results/{sample}/function/GSVA/{GROUP}.gobp.es.matrix.rds"
    log:
        "results/{sample}/logs/{GROUP}.gobp.gsva.log"
    benchmark:
        "results/{sample}/benchmark/{GROUP}.gobp.gsva.benchmark.txt"
    shell:
        """
        Rscript workflow/scripts/gsva.R -i {input} -o {output} -m {GOBP_PATH} > {log} 2>&1
        """