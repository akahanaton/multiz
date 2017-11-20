#!/usr/bin/env bash
set –euo pipefail

if [[ -e .snakemake ]]; then find .snakemake/ -delete ; fi
if [[ -e logs ]]; then find logs -delete ; fi
snakemake -q -j 200 -k -s ./snake.cmd.generate.snake --cluster-config cluster.json --cluster "qsub -j y -o logs -pe smp {cluster.smp} -l h_vmem={cluster.h_vmem}"

#--------------------------------------------------
# for queryDir in `ls -d batsGenome/eonSpe`
#--------------------------------------------------
#--------------------------------------------------
# for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
# do
#     queryID="`basename $queryDir`2"
#     nibQueryDir="$queryDir/$queryID.nib2"
# for targetDir in `ls -d batsGenome/pteAle`
# do
#     targetID=`basename $targetDir`
#     if [ $targetID != "hg38" ]; then
#         targetID=$targetID"2"
#     fi
#     if [[ $queryID == $targetID || $queryDone == *"$targetID"*  || $queryID == "eidHel2" || $queryID == "eonSpe2" ]]; then
#         continue
#     fi
#     lavQueryDir="$queryDir/$queryID.$targetID.lav"
#     pslQueryDir="$queryDir/$queryID.$targetID.psl"
#     chainQueryDir="$queryDir/$queryID.$targetID.chain"
#     nibTargetDir="$targetDir/$targetID.nib2"
#     snakeDir="snake.$queryID.$targetID"
#     for i in `find $nibQueryDir/ -name *.nib`
#     do
#         queryChr=`basename $i .nib`
#         if [[ ! -e $snakeDir/$queryChr.snake.done ]]; then
#             echo "find $lavQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.snake.cmd
#             echo "find $pslQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.snake.cmd
#             echo "find $chainQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.snake.cmd
#             touch $snakeDir/$queryChr.snake.done
#         fi
#     done
# done
# done
#--------------------------------------------------
