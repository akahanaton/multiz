
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

    lavQueryDir="$queryDir/$queryID.$targetID.lav"
    pslQueryDir="$queryDir/$queryID.$targetID.psl"
    chainQueryDir="$queryDir/$queryID.$targetID.chain"
    if [ ! -e $lavQueryDir ];  then mkdir $lavQueryDir; fi
    if [ ! -e $pslQueryDir ];  then mkdir $pslQueryDir; fi
    if [ ! -e $chainQueryDir ];  then mkdir $chainQueryDir; fi
    if [ ! -e $chainQueryDir/merge ];  then mkdir $chainQueryDir/merge; fi

    nibTargetDir="$targetDir/$targetID.nib2"

    snakeDir="snake.$queryID.$targetID"
    if [ ! -e $snakeDir ];  then mkdir $snakeDir; fi

    while read queryChromInfo
    do
        i=$nibQueryDir/`echo $queryChromInfo | awk '{print $2}'`.nib
        queryChr=`basename $i .nib`
        echo $queryChr

        echo "import glob, os" > $snakeDir/$queryChr.snake
        echo "queryNib='$queryChr'" >> $snakeDir/$queryChr.snake
        echo "targetNibs = [os.path.basename(f) for f in glob.glob('$nibTargetDir/*.nib')]" >> $snakeDir/$queryChr.snake

        echo "rule all:" >> $snakeDir/$queryChr.snake
        echo "  input: '$chainQueryDir/merge/' + queryNib + '.chain'" >> $snakeDir/$queryChr.snake

        echo "rule lastz:" >> $snakeDir/$queryChr.snake
        echo "  input:  queryNib='$nibQueryDir/' + queryNib + '.nib'," >> $snakeDir/$queryChr.snake
        echo "          targetNib='$nibTargetDir/{A}'" >> $snakeDir/$queryChr.snake
        echo "  output: '$lavQueryDir/' + queryNib + '_{A}.lav'" >> $snakeDir/$queryChr.snake
        echo "  shell: 'lastz {input.targetNib} {input.queryNib} --inner=2000 --ydrop=3400 --gappedthresh=3000 --hspthresh=3000 --notransition --step=4 > {output}'" >> $snakeDir/$queryChr.snake
        echo "rule psl:" >> $snakeDir/$queryChr.snake
        echo "  input: lavs='$lavQueryDir/' + queryNib + '_{A}.lav'" >> $snakeDir/$queryChr.snake
        echo "  output: psls='$pslQueryDir/' + queryNib + '_{A}.psl'" >> $snakeDir/$queryChr.snake
        echo "  shell: 'lavToPsl {input.lavs} {output.psls}'" >> $snakeDir/$queryChr.snake
        echo "rule chain:" >> $snakeDir/$queryChr.snake
        echo "    input: psls='$pslQueryDir/' + queryNib + '_{A}.psl'" >> $snakeDir/$queryChr.snake
        echo "    output: '$chainQueryDir/' + queryNib + '_{A}.chain'" >> $snakeDir/$queryChr.snake
        echo "    shell: 'axtChain.raw -linearGap=loose -psl {input.psls} $nibTargetDir $nibQueryDir {output.chains}'" >> $snakeDir/$queryChr.snake
        echo "rule chainMerge:" >> $snakeDir/$queryChr.snake
        echo "    input: chains=expand('$chainQueryDir/' + queryNib + '_{A}.chain', A=targetNibs)" >> $snakeDir/$queryChr.snake
        echo "    output: '$chainQueryDir/merge/' + queryNib + '.chain'" >> $snakeDir/$queryChr.snake
        echo "    shell: 'chainMergeSort -tempDir=$chainQueryDir/merge {input.chains} > {output}'" >> $snakeDir/$queryChr.snake

    done < $queryDir/$queryID.chrom.index

    #--------------------------------------------------
    # netCmdDir="cmdNet.$queryID.$targetID"
    # if [ ! -e $netCmdDir ];  then mkdir $netCmdDir; fi
    # echo '#!/bin/bash' > $netCmdDir/a.chainNet.sh
    # echo "chainMergeSort -tempDir=$chainQueryDir/merge $chainQueryDir/merge/*.chain > $queryDir/$queryID.$targetID.all.chain" >> $netCmdDir/a.chainNet.sh
    # echo "chainPreNet $queryDir/$queryID.$targetID.all.chain $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.pre.chain" >> $netCmdDir/a.chainNet.sh
    # echo "chainNet $queryDir/$queryID.$targetID.pre.chain -minSpace=1 $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes stdout $queryDir/$queryID.$targetID.chainNet.err | netSyntenic stdin $queryDir/$queryID.$targetID.noClass.net" >> $netCmdDir/a.chainNet.sh
    #--------------------------------------------------
    #--------------------------------------------------
    # qsub -o $netCmdDir -N "a.chainNet" bash $netCmdDir/a.chainNet.sh
    #--------------------------------------------------

    #--------------------------------------------------
    # echo 'cd $PBS_O_WORKDIR' > $netCmdDir/b.netClass.sh
    # echo "netClass -noAr $queryDir/$queryID.$targetID.noClass.net $targetID $queryID $queryDir/$queryID.$targetID.net" >> $netCmdDir/b.netClass.sh
    # echo "qsub -o $netCmdDir -e $netCmdDir -j oe -N 'b.netClass' $netCmdDir/b.netClass.sh"
    #--------------------------------------------------

    #--------------------------------------------------
    # echo '#!/bin/bash' > $netCmdDir/c.maf.sh
    # echo "netToAxt $queryDir/$queryID.$targetID.net $queryDir/$queryID.$targetID.pre.chain $targetDir/$targetID.2bit $queryDir/$queryID.2bit stdout | axtSort stdin $queryDir/$queryID.$targetID.axt" >> $netCmdDir/c.maf.sh
    # echo "axtToMaf $queryDir/$queryID.$targetID.axt $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.maf -tPrefix=$targetID. -qPrefix=$queryID." >> $netCmdDir/c.maf.sh
    # qsub -o $netCmdDir -N "c.maf" bash $netCmdDir/c.maf.sh
    #--------------------------------------------------

done
done

