# fam-gwas

To run the pipeline:
```
nextflow run lifebit-ai/fam-gwas --vcf s3://lifebit-featured-datasets/pipelines/fam-gwas-data/threechrs.vcf --data s3://lifebit-featured-datasets/pipelines/fam-gwas-data/threechrs.phe
```
```
Unable to find any JVMs matching version "1.8".
N E X T F L O W  ~  version 18.10.1
Launching `main.nf` [angry_caravaggio] - revision: a3a1631b30
[warm up] executor > local
[64/816edd] Submitted process > vcf2plink (1)
[43/100759] Submitted process > association (1)
[59/9a53ba] Submitted process > plots (1)
[98/dfaf3e] Submitted process > visualisations (1)
```

For more documentation see [gitbook](https://lifebit.gitbook.io/deploit/pipelines-documentations-and-examples-1/nextflow-pipelines/family-based-gwas)
