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

process association {
    publishDir "${params.outdir}/associations", mode: 'copy'

    input:
    set file(bed), file(bim), file(fam) from plink

    output:
    file('*') into asssociation

    script:
    """
    plink --bfile plink --mind $params.mind --geno $params.geno --maf $params.maf --hwe $params.hwe --me $params.me 0.1 --ci $params.ci --tdt
    plink --bfile plink --mind $params.mind --geno $params.geno --maf $params.maf --hwe $params.hwe --me $params.me 0.1 --ci $params.ci --tdt poo
    plink --bfile plink --mind $params.mind --geno $params.geno --maf $params.maf --hwe $params.hwe --me $params.me 0.1 --ci $params.ci --dfam
    """
}

process plots {
    publishDir "${params.outdir}/plots", mode: 'copy'

    input:
    file results from asssociation

    output:
    set file("QQdfam.png"), file("QQpoo.png"), file("QQtdt.png"), file("tdt.png") into plots

    script:
    """
    plot.R
    """
}


process visualisations {
    publishDir "${params.outdir}/Visualisations", mode: 'copy'

    container 'lifebitai/vizjson:latest'

    input:
    set file(qq_dfam), file(qq_poo), file(qq_tdt), file(tdt) from plots

    output:
    file '.report.json' into viz

    script:
    """
    for image in \$(ls *png); do
        prefix="\${image%.*}"
        if [[ \$prefix == "QQdfam" ]]; then
            title="QQ Plot From The Sib-TDT Test To Show Family-based Disease Traits"
        elif [ \$prefix == "QQpoo" ]; then
            title="QQ Plot For The Parent of Orgin Analysis"
        elif [ \$prefix == "QQtdt" ]; then
            title="QQ Plot From The Transmission Disequilibrium Test To Show Family-based Associations"
        elif [ \$prefix == "tdt" ]; then
            title="Manhattan Plot From The Transmission Disequilibrium Test To Show Family-based Associations"
        fi
        img2json.py "${params.outdir}/plots/\$image" "\$title" \${prefix}.json
    done
    
    #table=\$(ls *.txt)
    #prefix=\${table%.*}
    #tsv2csv.py < \${prefix}.txt > \${prefix}.csv
    #csv2json.py \${prefix}.csv "Combined Results" 'results-combined.json'
    
    combine_reports.py .
    """
}