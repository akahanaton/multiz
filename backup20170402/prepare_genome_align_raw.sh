#--------------------------------------------------
# for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
for queryDir in `ls -d batsGenome/eonSpe`
do
    queryID="`basename $queryDir`2"
    queryDone="$queryDone$queryID"
    echo $queryDone
    genomic=`basename $queryDir/*genomic.fa`
#--------------------------------------------------
# for targetDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]* ucsc/hg38`
#--------------------------------------------------
for targetDir in `ls -d ucsc/hg38`
do
    targetID=`basename $targetDir`
    if [ $targetID != "hg38" ]; then
        targetID=$targetID"2"
    fi
    #--------------------------------------------------
    # ls $queryDir/$genomic
    #--------------------------------------------------
    if [[ $queryID == $targetID || $queryDone == *"$targetID"* ]]; then
        continue
    fi
    echo $queryID.vs.$targetID
    nibQueryDir="$queryDir/$queryID.nib2"
    lavQueryDir="$queryDir/$queryID.$targetID.lav"
    pslQueryDir="$queryDir/$queryID.$targetID.psl"
    chainQueryDir="$queryDir/$queryID.$targetID.chain"
    if [ ! -e $lavQueryDir ];  then mkdir $lavQueryDir; fi
    if [ ! -e $pslQueryDir ];  then mkdir $pslQueryDir; fi
    if [ ! -e $chainQueryDir ];  then mkdir $chainQueryDir; fi
    if [ ! -e $chainQueryDir/merge ];  then mkdir $chainQueryDir/merge; fi

    nibTargetDir="$targetDir/$targetID.nib2"

    queryChrNum=`wc -l $queryDir/$queryID.chrom.sizes | awk '{print $1}'`
    lavCmdDir="cmdLav.$queryID.$targetID"
    if [ ! -e $lavCmdDir ];  then mkdir $lavCmdDir; fi

    # 55 lines, print the lastz commands
    #--------------------------------------------------
    # if [[ $queryChrNum -ge 3000 ]]; then
    #     for queryIndex in {0..3000}; do
    #         echo "if [ ! -e $lavQueryDir/$queryIndex ];  then mkdir $lavQueryDir/$queryIndex; fi" > $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "if [ ! -e $pslQueryDir/$queryIndex ];  then mkdir $pslQueryDir/$queryIndex; fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "if [ ! -e $chainQueryDir/$queryIndex ];  then mkdir $chainQueryDir/$queryIndex; fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "for targetIndex in {0..3000}; do" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "    if [ ! -e $lavQueryDir/$queryIndex/\$targetIndex ];then mkdir $lavQueryDir/$queryIndex/\$targetIndex;fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "    if [ ! -e $pslQueryDir/$queryIndex/\$targetIndex ];then mkdir $pslQueryDir/$queryIndex/\$targetIndex;fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "done">>$lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     done
    # else
    #     for queryIndex in {0..$queryChrNum}; do
    #         echo "if [ ! -e $lavQueryDir/$queryIndex ];  then mkdir $lavQueryDir/$queryIndex; fi" > $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "if [ ! -e $pslQueryDir/$queryIndex ];  then mkdir $pslQueryDir/$queryIndex; fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "if [ ! -e $chainQueryDir/$queryIndex ];  then mkdir $chainQueryDir/$queryIndex; fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "for targetIndex in {0..3000}; do" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "    if [ ! -e $lavQueryDir/$queryIndex/\$targetIndex ];then mkdir $lavQueryDir/$queryIndex/\$targetIndex;fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "    if [ ! -e $pslQueryDir/$queryIndex/\$targetIndex ];then mkdir $pslQueryDir/$queryIndex/\$targetIndex;fi" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "done">>$lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     done
    # fi
    #--------------------------------------------------

    #--------------------------------------------------
    # while read chromInfo
    # do
    #     queryIndex=`echo $chromInfo | awk '{print $1}'`
    #     i=$nibQueryDir/`echo $chromInfo | awk '{print $2}'`.nib
    #     queryChr=`basename $i .nib`
    #     echo "while read chromInfo; do" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    targetIndex=\`echo \$chromInfo | awk '{print \$1}'\`" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    j=$nibTargetDir/\`echo \$chromInfo | awk '{print \$2}'\`.nib" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    targetChr=\`basename \$j .nib\`;" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    lav=$lavQueryDir/$queryIndex/\$targetIndex/$queryID.$targetID.$queryChr.\$targetChr.lav" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    psl=\`echo \$lav | sed 's/lav/psl/g'\`" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    chain=$chainQueryDir/$queryIndex/$queryID.$targetID.$queryChr.\$targetChr.chain" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    lastz \$j $i --inner=2000 --ydrop=3400 --gappedthresh=3000 --hspthresh=3000 --notransition --step=4 --scores=HaploMerger_20120810/project_template/scoreMatrix.q > \$lav;" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo '    lavToPsl $lav $psl' >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "    axtChain -linearGap=loose -psl \$psl $nibTargetDir $nibQueryDir \$chain" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "done < $targetDir/$targetID.chrom.index" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #     echo "" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    # done < $queryDir/$queryID.chrom.index
    #--------------------------------------------------

    #--------------------------------------------------
    # for queryIndex in {0..3000}; do
    #     if [ -e $lavCmdDir/$queryID.$targetID.$queryIndex.sh ]; then
    #         echo "chainMergeSort -tempDir=$chainQueryDir/merge $chainQueryDir/$queryIndex/*.chain > $chainQueryDir/merge/$queryIndex.chain" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         echo "touch $lavCmdDir/$queryID.$targetID.$queryIndex.done" >> $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         #--------------------------------------------------
    #         # qsub -q "all.q@compute-9-*,all.q@compute-8-1*" -o $lavCmdDir -N $queryID.$targetID.$queryIndex bash $lavCmdDir/$queryID.$targetID.$queryIndex.sh
    #         #--------------------------------------------------
    #     fi
    # done
    #--------------------------------------------------

    netCmdDir="cmdNet.$queryID.$targetID"
    if [ ! -e $netCmdDir ];  then mkdir $netCmdDir; fi
    echo '#!/bin/bash' > $netCmdDir/a.chainNet.sh
    echo "chainMergeSort -tempDir=$chainQueryDir/merge $chainQueryDir/merge/*.chain > $queryDir/$queryID.$targetID.all.chain" >> $netCmdDir/a.chainNet.sh
    echo "chainPreNet $queryDir/$queryID.$targetID.all.chain $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.pre.chain" >> $netCmdDir/a.chainNet.sh
    echo "chainNet $queryDir/$queryID.$targetID.pre.chain -minSpace=1 $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes stdout $queryDir/$queryID.$targetID.chainNet.err | netSyntenic stdin $queryDir/$queryID.$targetID.noClass.net" >> $netCmdDir/a.chainNet.sh
    #--------------------------------------------------
    # qsub -o $netCmdDir -N "a.chainNet" bash $netCmdDir/a.chainNet.sh
    #--------------------------------------------------

    echo 'cd $PBS_O_WORKDIR' > $netCmdDir/b.netClass.sh
    echo "netClass -noAr $queryDir/$queryID.$targetID.noClass.net $targetID $queryID $queryDir/$queryID.$targetID.net" >> $netCmdDir/b.netClass.sh
    echo "qsub -o $netCmdDir -e $netCmdDir -j oe -N 'b.netClass' $netCmdDir/b.netClass.sh"

    echo '#!/bin/bash' > $netCmdDir/c.maf.sh
    echo "netToAxt $queryDir/$queryID.$targetID.net $queryDir/$queryID.$targetID.pre.chain $targetDir/$targetID.2bit $queryDir/$queryID.2bit stdout | axtSort stdin $queryDir/$queryID.$targetID.axt" >> $netCmdDir/c.maf.sh
    echo "axtToMaf $queryDir/$queryID.$targetID.axt $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.maf -tPrefix=$targetID. -qPrefix=$queryID." >> $netCmdDir/c.maf.sh
    qsub -o $netCmdDir -N "c.maf" bash $netCmdDir/c.maf.sh

done
done
