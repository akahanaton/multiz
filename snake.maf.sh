for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
# for queryDir in `ls -d batsGenome/eonSpe`
#--------------------------------------------------
do
    queryID="`basename $queryDir`2"
    queryDone="$queryDone$queryID"
    #--------------------------------------------------
    # echo $queryDone
    #--------------------------------------------------
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
    nibQueryDir="$queryDir/$queryID.nib2"
    lavQueryDir="$queryDir/$queryID.$targetID.lav"
    pslQueryDir="$queryDir/$queryID.$targetID.psl"
    chainQueryDir="$queryDir/$queryID.$targetID.chain"

    echo $chainQueryDir

    if [ ! -e $lavQueryDir ];  then mkdir $lavQueryDir; fi
    if [ ! -e $pslQueryDir ];  then mkdir $pslQueryDir; fi
    if [ ! -e $chainQueryDir ];  then mkdir $chainQueryDir; fi
    if [ ! -e $chainQueryDir/merge ];  then mkdir $chainQueryDir/merge; fi
    if [ ! -e $chainQueryDir/done ];  then mkdir $chainQueryDir/done; fi

    nibTargetDir="$targetDir/$targetID.nib2"

    queryChrNum=`wc -l $queryDir/$queryID.chrom.sizes | awk '{print $1}'`

    netCmdDir="cmdNet.$queryID.$targetID"
    if [ ! -e $netCmdDir ];  then mkdir $netCmdDir; fi
    if [[ "login-7-1" == `hostname` ]] && [[ ! -e $queryDir/$queryID.$targetID.noClass.net ]]; then
        echo '#!/bin/bash' > $netCmdDir/a.chainNet.sh
        echo "chainMergeSort -tempDir=$chainQueryDir/merge $chainQueryDir/done/*.chain > $queryDir/$queryID.$targetID.all.chain" >> $netCmdDir/a.chainNet.sh
        echo "chainPreNet $queryDir/$queryID.$targetID.all.chain $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.pre.chain" >> $netCmdDir/a.chainNet.sh
        echo "chainNet $queryDir/$queryID.$targetID.pre.chain -minSpace=1 $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes stdout $queryDir/$queryID.$targetID.chainNet.err | netSyntenic stdin $queryDir/$queryID.$targetID.noClass.net" >> $netCmdDir/a.chainNet.sh
        qsub -o $netCmdDir -N "a.chainNet" bash $netCmdDir/a.chainNet.sh
    fi

    # run on gentoo
    if [[ "gentoo" == `hostname` ]] && [[ -e $queryDir/$queryID.$targetID.noClass.net ]] && [[ ! -e $queryDir/$queryID.$targetID.net ]]; then
        echo 'cd $PBS_O_WORKDIR' > $netCmdDir/b.netClass.sh
        echo "netClass -noAr $queryDir/$queryID.$targetID.noClass.net $targetID $queryID $queryDir/$queryID.$targetID.net" >> $netCmdDir/b.netClass.sh
        qsub -o $netCmdDir -e $netCmdDir -j oe -N 'b.netClass' $netCmdDir/b.netClass.sh
    fi

    if [[ "login-7-1" == `hostname` ]] && [[ -e $queryDir/$queryID.$targetID.net ]] && [[ ! -e $queryDir/$queryID.$targetID.maf ]]; then
        echo '#!/bin/bash' > $netCmdDir/c.maf.sh
        echo "netToAxt $queryDir/$queryID.$targetID.net $queryDir/$queryID.$targetID.pre.chain $targetDir/$targetID.2bit $queryDir/$queryID.2bit stdout |axtSort stdin $queryDir/$queryID.$targetID.axt" >>$netCmdDir/c.maf.sh
        echo "axtToMaf $queryDir/$queryID.$targetID.axt $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.maf -tPrefix=$targetID. -qPrefix=$queryID." >> $netCmdDir/c.maf.sh
        qsub -o $netCmdDir -N "c.maf" bash $netCmdDir/c.maf.sh
    fi

done
done
