for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
# for queryDir in `ls -d batsGenome/eonSpe`
#--------------------------------------------------
do
    queryID="`basename $queryDir`2"
    nibQueryDir="$queryDir/$queryID.nib2"
    for targetDir in `ls -d ucsc/hg38`
    do
        targetID=`basename $targetDir`
        snakeDir=snake.$queryID.$targetID
        lavQueryDir="$queryDir/$queryID.$targetID.lav"
        pslQueryDir="$queryDir/$queryID.$targetID.psl"
        chainQueryDir="$queryDir/$queryID.$targetID.chain"
        echo $snakeDir
        for snake in $snakeDir/*.snake
        do
            queryChr=`basename $snake .snake`
            #--------------------------------------------------
            # mkdir $lavQueryDir/$queryChr
            # mkdir $pslQueryDir/$queryChr
            # mkdir $chainQueryDir/$queryChr
            #--------------------------------------------------
        done
        #--------------------------------------------------
        # mkdir $chainQueryDir/done
        #--------------------------------------------------
        #--------------------------------------------------
        # for chain in `ls -f $chainQueryDir/done/*.chain`
        # do
        #     queryChr=`basename $chain .chain`
        #     mv $chain $chainQueryDir/done
        #     #--------------------------------------------------
        #     # mv snake.$queryID.$targetID/$queryChr.* snake.$queryID.$targetID.cmd
        #     #--------------------------------------------------
        # done
        #--------------------------------------------------
        if [ "$(ls -A $chainQueryDir/merge)"  ]; then
            mv $chainQueryDir/merge/*.chain $chainQueryDir/done/
        fi
        find $nibQueryDir/ -name "*.nib" | wc -l
        find $chainQueryDir/done/ -name "*.chain" | wc -l
        find $chainQueryDir/merge/ -name "*.chain" | wc -l
        find $snakeDir/ -name "*.snake" | wc -l
        find $snakeDir/ -name "*.cmd" | wc -l
        #--------------------------------------------------
        # find snake.$queryID.$targetID.cmd/ -name "*.snake" | wc -l
        #--------------------------------------------------
    done
done
