#!/usr/bin/env bash
set –euo pipefail
#--------------------------------------------------
# dir=snake.pteAle2.eonSpe2
# for snake in `ls -f ./$dir/*.snake`
# do
#     if [[ -e $snake.cmd ]]; then
#         mv ${snake} ./$dir.cmd
#     fi
# done
#--------------------------------------------------

queryID=pteAle
targetID=eonSpe
queryID2=${queryID}2
targetID2=${targetID}2

for cmd in `ls -f snake.$queryID2.$targetID2/ | grep 'cmd$'`
do
    queryChr=`basename $cmd .snake.cmd`
    if [[ -e ./batsGenome/$queryID/$queryID2.$targetID2.chain/$queryChr.chain.list ]]; then
        mv snake.$queryID2.$targetID2/$cmd snake.$queryID2.$targetID2.cmd
        echo $queryChr
        #--------------------------------------------------
        # find batsGenome/$queryID/$queryID2.$targetID2.chain/$queryChr -delete
        # find batsGenome/$queryID/$queryID2.$targetID2.lav/$queryChr -delete
        # find batsGenome/$queryID/$queryID2.$targetID2.psl/$queryChr -delete
        #--------------------------------------------------
    fi
done
