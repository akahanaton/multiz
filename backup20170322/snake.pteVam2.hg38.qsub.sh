#!/bin/bash
#--------------------------------------------------
# for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
for queryDir in `ls -d batsGenome/pteVam`
do
    queryID="`basename $queryDir`2"
    queryDone="$queryDone$queryID"
    echo $queryDone
    genomic=`basename $queryDir/*genomic.fa`
    nibQueryDir="$queryDir/$queryID.nib2"
#--------------------------------------------------
# for targetDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]* ucsc/hg38`
#--------------------------------------------------
for targetDir in `ls -d ucsc/hg38`
do
    targetID=`basename $targetDir`
    if [ $targetID != "hg38" ]; then
        targetID=$targetID"2"
    fi
    if [[ $queryID == $targetID || $queryDone == *"$targetID"* ]]; then continue; fi

    snakeDir="snake.$queryID.$targetID"

    if [ -e $snakeDir ]; then

        echo $snakeDir

        for snake in ./$snakeDir/*.snake
        do
            chrID=`basename $snake .snake`

            if [ -e $chainQueryDir/merge/$chrID.chain ]; then continue; fi

            lavQueryDir="$queryDir/$queryID.$targetID.lav"
            pslQueryDir="$queryDir/$queryID.$targetID.psl"
            chainQueryDir="$queryDir/$queryID.$targetID.chain"
            if [ ! -e $lavQueryDir ];  then mkdir $lavQueryDir; fi
            if [ ! -e $pslQueryDir ];  then mkdir $pslQueryDir; fi
            if [ ! -e $chainQueryDir ];  then mkdir $chainQueryDir; fi
            if [ ! -e $lavQueryDir/$chrID ];  then mkdir $lavQueryDir/$chrID; fi
            if [ ! -e $pslQueryDir/$chrID ];  then mkdir $pslQueryDir/$chrID; fi
            if [ ! -e $chainQueryDir/$chrID ];  then mkdir $chainQueryDir/$chrID; fi
            if [ ! -e $chainQueryDir/merge ];  then mkdir $chainQueryDir/merge; fi
            if [ ! -e $chainQueryDir/sort ];  then mkdir $chainQueryDir/sort; fi

            snakemake -q -j 800 --cluster "qsub -o /dev/null -j y" -s $snake

            #--------------------------------------------------
            # cd $chainQueryDir/$chrID
            # qsub -o /dev/null chainMergeSort *.chain > ../merge/$chrID.chain
            # cd -
            #--------------------------------------------------
            qsub -o /dev/null find $lavQueryDir/$chrID -delete
            qsub -o /dev/null find $pslQueryDir/$chrID -delete
            qsub -o /dev/null find $chainQueryDir/$chrID -delete
            qsub -o /dev/null find ./.snakemake/code_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/input_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/params_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/rule_tracking -type f -atime 0.05 -delete
            qsub -o /dev/null find ./.snakemake/shellcmd_tracking -type f -atime 0.05 -delete
        done
    fi
done
done
