find snake.*2.hg38 -name "*.cmd" -exec sed -i 's/qsub -o \/dev\/null //' {} \;
