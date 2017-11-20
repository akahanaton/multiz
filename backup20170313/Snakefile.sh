snakemake -np # dry run, for testing
snakemake -j 99 --cluster-config snakemake.cluster.json --cluster "qsub -j y -pe smp {cluster.smp} -l h_vmem={cluster.h_vmem}"
