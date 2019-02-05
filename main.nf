#!/usr/bin/env nextflow

Channel.fromPath(params.vcf)
    .ifEmpty { exit 1, "VCF file not found: ${params.vcf}" }
    .set { vcf }
Channel.fromPath(params.data)
    .ifEmpty { exit 1, "FAM file (w/ header) containing phenotype data not found: ${params.data}" }
    .set { data }

process vcf2plink {
    publishDir "${params.outdir}/vcf2plink", mode: 'copy'

    input:
    file vcf from vcf
    file fam from data

    output:
    set file('*.bed'), file('*.bim'), file('*.fam') into plink

    script:
    """
    sed '1d' $fam > tmpfile; mv tmpfile $fam
    plink --vcf $vcf
    rm plink.fam
    mv $fam plink.fam
    """
}

// process filter {
//     publishDir "${params.output_dir}/filter", mode: 'copy'

//     input:
//     set file(bed), file(bim), file(fam) from plink

//     output:
//     file('*') into results

//     script:
//     """
//     plink --bfile plink --mind 0.1 --geno 0.1 --maf 0.05 --hwe 0.000001 --me 0.05 0.1 --tdt --ci 0.95 --out results1
//     """
// }


process association {
    publishDir "${params.outdir}/associations", mode: 'copy'

    input:
    set file(bed), file(bim), file(fam) from plink

    output:
    file('*') into asssociation

    script:
    """
    plink --bfile plink --tdt
    plink --bfile plink --tdt poo
    plink --bfile plink --dfam
    """
}

process plots {
    publishDir "${params.outdir}/plots", mode: 'copy'

    input:
    file results from asssociation

    output:
    file('*') into plot

    script:
    """
    plot.R
    """
}