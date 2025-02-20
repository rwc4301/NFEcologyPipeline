#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.input = "input_data.csv"
params.outdir = "results"

process RUN_R_SCRIPT {
    input:
    path input_file
    path script

    output:
    path "${script.baseName}.out.txt"

    script:
    """
    Rscript ${script} ${input_file} > ${script.baseName}.out.txt
    """
}

workflow {
    Channel.fromPath("scripts/*.R").set { r_scripts }

    r_scripts
        .map { script -> tuple(file(params.input), script) }
        | RUN_R_SCRIPT
        | view
}
