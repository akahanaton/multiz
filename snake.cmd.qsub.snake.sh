find .snakemake/ -delete
if [[ -e logs ]]; then find logs -delete; fi
mkdir logs
snakemake -q -j 100 -k --cluster "qsub -o ./logs -j y" -s snake.cmd.qsub.snake
