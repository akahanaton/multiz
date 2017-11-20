#--------------------------------------------------
# for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
for queryDir in `ls -d batsGenome/eonSpe`
do
    queryID="`basename $queryDir`2"
    queryDone="$queryDone$queryID"
    echo $queryDone
    genomic=`basename $queryDir/*genomic.fa`
    nibQueryDir="$queryDir/$queryID.nib2"
#--------------------------------------------------
# for targetDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]* ucsc/hg38`
#--------------------------------------------------
for targetDir in `ls -d batsGenome/pteAle`
do
    targetID=`basename $targetDir`
    if [ $targetID != "hg38" ]; then
        targetID=$targetID"2"
    fi
    if [[ $queryID == $targetID || $queryDone == *"$targetID"* ]]; then
        continue
    fi
    echo $queryID.vs.$targetID

    snakeDir="snake.$queryID.$targetID"

    for snake in ./$snakeDir/*.snake
    do
        chrID=`basename $snake .snake`
        #--------------------------------------------------
        # if [ ! -e snake.log.$chrID ]; then mkdir snake.log.$chrID; fi
        #--------------------------------------------------

        lavQueryDir="$queryDir/$queryID.$targetID.lav"
        pslQueryDir="$queryDir/$queryID.$targetID.psl"
        chainQueryDir="$queryDir/$queryID.$targetID.chain"
        if [ ! -e $lavQueryDir/$chrID ];  then mkdir $lavQueryDir/$chrID; fi
        if [ ! -e $pslQueryDir/$chrID ];  then mkdir $pslQueryDir/$chrID; fi
        if [ ! -e $chainQueryDir/$chrID ];  then mkdir $chainQueryDir/$chrID; fi

        snakemake -j 800 --cluster "qsub -o /dev/null -j y -q 'all.q@compute-9-*'" -s $snake

        #--------------------------------------------------
        # qsub find $lavQueryDir/$chrID -delete
        # qsub find $pslQueryDir/$chrID -delete
        # qsub find $chainQueryDir/$chrID -delete
        #--------------------------------------------------
    done
done
done
