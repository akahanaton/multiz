            qsub -o /dev/null find ./.snakemake/code_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/input_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/params_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/rule_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/shellcmd_tracking -type f -atime 0.05 -delete
