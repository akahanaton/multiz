#!/bin/bash
for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
# for queryDir in `ls -d batsGenome/eonSpe`
#--------------------------------------------------
do
    queryID="`basename $queryDir`2"
    #--------------------------------------------------
    # queryDone="$queryDone$queryID"
    # echo $queryDone
    #--------------------------------------------------
    genomic=`basename $queryDir/*genomic.fa`
    nibQueryDir="$queryDir/$queryID.nib2"
#--------------------------------------------------
# for targetDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]* ucsc/hg38`
#--------------------------------------------------
#--------------------------------------------------
# for targetDir in `ls -d ucsc/hg38` # done
#--------------------------------------------------
#--------------------------------------------------
# for targetDir in `ls -d batsGenome/eonSpe`
#--------------------------------------------------
for targetDir in `ls -d batsGenome/pteAle`
do
    targetID=`basename $targetDir`
    lastzPara="M=40 K=3000 L=3000 Y=9400 E=30 H=0 O=400 T=1"
    if [ $targetID != "hg38" ]; then
        targetID=$targetID"2"
        lastzPara="M=40 K=3000 L=3000 Y=9400 E=30 H=0 O=400 T=1"
    fi
    if [[ $queryID == $targetID || $queryDone == *"$targetID"* ]]; then
        continue
    fi

    lavQueryDir="$queryDir/$queryID.$targetID.lav"
    pslQueryDir="$queryDir/$queryID.$targetID.psl"
    chainQueryDir="$queryDir/$queryID.$targetID.chain"
    if [ ! -e $lavQueryDir ];  then mkdir $lavQueryDir; fi
    if [ ! -e $pslQueryDir ];  then mkdir $pslQueryDir; fi
    if [ ! -e $chainQueryDir ];  then mkdir $chainQueryDir; fi
    if [ ! -e $chainQueryDir/merge ];  then mkdir $chainQueryDir/merge; fi
    if [ ! -e $chainQueryDir/sort ];  then mkdir $chainQueryDir/sort; fi
    if [ ! -e $chainQueryDir/done ];  then mkdir $chainQueryDir/done; fi

    nibTargetDir="$targetDir/$targetID.nib2"

    snakeDir="snake.$queryID.$targetID"
    echo $snakeDir

    if [ ! -e $snakeDir ];  then mkdir $snakeDir; fi

    #--------------------------------------------------
    # while read queryChromInfo
    #--------------------------------------------------
    for i in `find $nibQueryDir/ -name *.nib`
    do
        #--------------------------------------------------
        # i=$nibQueryDir/`echo $queryChromInfo | awk '{print $2}'`.nib
        #--------------------------------------------------
        queryChr=`basename $i .nib`

        if [[ -e $chainQueryDir/done/$queryChr.chain ]]; then
            if [[ -e $snakeDir/$queryChr.snake ]]; then mv $snakeDir/$queryChr.* $snakeDir.cmd; fi
        else
            if [[ -e $snakeDir/$queryChr.snake ]]; then
                if [[ ! -e $snakeDir/$queryChr.cmd ]]; then
                    snakemake -npq -s $snakeDir/$queryChr.snake > $snakeDir/$queryChr.cmd
                    echo "find $lavQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.cmd
                    echo "find $pslQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.cmd
                    echo "find $chainQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.cmd
                fi
            else
                echo "import glob, os" > $snakeDir/$queryChr.snake
                echo "queryNib='$queryChr'" >> $snakeDir/$queryChr.snake
                echo "targetNibs = [os.path.basename(f) for f in glob.glob('$nibTargetDir/*.nib')]" >> $snakeDir/$queryChr.snake
                echo "rule all:" >> $snakeDir/$queryChr.snake
                echo "  input: '$chainQueryDir/merge/' + queryNib + '.chain'" >> $snakeDir/$queryChr.snake
                echo "rule lastz:" >> $snakeDir/$queryChr.snake
                echo "  input:  queryNib='$nibQueryDir/' + queryNib + '.nib'," >> $snakeDir/$queryChr.snake
                echo "          targetNib='$nibTargetDir/{A}'" >> $snakeDir/$queryChr.snake
                echo "  output: lavs='$lavQueryDir/$queryChr/{A}.lav'," >> $snakeDir/$queryChr.snake
                echo "          psls='$pslQueryDir/$queryChr/{A}.psl'," >> $snakeDir/$queryChr.snake
                echo "          chains='$chainQueryDir/$queryChr/{A}.chain'" >> $snakeDir/$queryChr.snake
                echo "  shell: 'lastz {input.targetNib} {input.queryNib} $lastzPara > {output.lavs}; lavToPsl {output.lavs} {output.psls}; axtChain.raw -linearGap=loose -psl {output.psls} $nibTargetDir $nibQueryDir {output.chains}'" >> $snakeDir/$queryChr.snake
                echo "rule chainList:" >> $snakeDir/$queryChr.snake
                echo "    input: chains=expand('$chainQueryDir/$queryChr/{A}.chain', A=targetNibs)" >> $snakeDir/$queryChr.snake
                echo "    output: '$chainQueryDir/' + queryNib + '.chain.list'" >> $snakeDir/$queryChr.snake
                echo "    shell: 'find $chainQueryDir/$queryChr/ -name *.chain  > {output}'" >> $snakeDir/$queryChr.snake
                echo "rule chainMerge:" >> $snakeDir/$queryChr.snake
                echo "    input: '$chainQueryDir/' + queryNib + '.chain.list'" >> $snakeDir/$queryChr.snake
                echo "    output: '$chainQueryDir/merge/' + queryNib + '.chain'" >> $snakeDir/$queryChr.snake
                echo "    shell: 'chainMergeSort -tempDir=$chainQueryDir/sort -inputList={input} > {output}'" >> $snakeDir/$queryChr.snake
                #--------------------------------------------------
                # snakemake -npq -s $snakeDir/$queryChr.snake > $snakeDir/$queryChr.cmd
                # echo "find $lavQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.cmd
                # echo "find $pslQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.cmd
                # echo "find $chainQueryDir/$queryChr -delete" >> $snakeDir/$queryChr.cmd
                #--------------------------------------------------
            fi
        fi

    done
    #--------------------------------------------------
    # done < $queryDir/$queryID.chrom.index
    #--------------------------------------------------

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

