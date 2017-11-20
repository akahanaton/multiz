#--------------------------------------------------
# for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
for queryDir in `ls -d batsGenome/eonSpe batsGenome/pteAle ucsc/hg38`
do
    queryID="`basename $queryDir`1"
    queryDone="$queryDone$queryID"
    echo $queryDone
    genomic=`basename $queryDir/$queryID.fa`
    nibQueryDir="$queryDir/$queryID.nib1"
#--------------------------------------------------
# for targetDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]* ucsc/hg38`
#--------------------------------------------------
#--------------------------------------------------
# for targetDir in `ls -d batsGenome/pteAle`
#--------------------------------------------------
for queryDir in `ls -d batsGenome/eonSpe batsGenome/pteAle ucsc/hg38`
do
    targetID=`basename $targetDir`
    if [ $targetID != "hg38" ]; then
        targetID=$targetID"1"
    fi
    #--------------------------------------------------
    # ls $queryDir/$genomic
    #--------------------------------------------------
    if [[ $queryID == $targetID || $queryDone == *"$targetID"* ]]; then
        continue
    fi
    echo $queryID.vs.$targetID

    nibTargetDir="$targetDir/$targetID.nib1"

    lavQueryDir="$queryDir/$queryID.$targetID.lav"
    pslQueryDir="$queryDir/$queryID.$targetID.psl"
    chainQueryDir="$queryDir/$queryID.$targetID.chain"
    lavCmdDir="cmdLav.$queryID.$targetID"
    netCmdDir="cmdNet.$queryID.$targetID"
    rm -rf $lavCmdDir
    if [ ! -e $lavCmdDir ];  then mkdir $lavCmdDir; fi
    if [ ! -e $lavQueryDir ];  then mkdir $lavQueryDir; fi
    if [ ! -e $pslQueryDir ];  then mkdir $pslQueryDir; fi
    if [ ! -e $chainQueryDir ];  then mkdir $chainQueryDir; fi

    for queryNib in $nibQueryDir/*.nib
    do
        queryChr=`basename $queryNib .nib`
        bashFile=$lavCmdDir/$queryID.$targetID.$queryChr.sh
        echo "#!/bin/bash" > $bashFile
        echo "for targetNib in $nibTargetDir/*.nib; do" >> $bashFile
        echo "    targetChr=\`basename \$targetNib .nib\`;" >> $bashFile
        echo "    lav=$lavQueryDir/$queryID.$targetID.$queryChr.\$targetChr.lav" >> $bashFile
        echo "    psl=\`echo \$lav | sed 's/lav/psl/g'\`" >> $bashFile
        echo "    chain=\`echo \$lav | sed 's/lav/chain/g'\`" >> $bashFile
        echo "    lastz \$targetNib $queryNib --inner=2000 --ydrop=3400 --gappedthresh=3000 --hspthresh=3000 --notransition --step=4 --scores=HaploMerger_20120810/project_template/scoreMatrix.q > \$lav;" >> $bashFile
        echo '    lavToPsl $lav $psl' >> $bashFile
        echo "    axtChain -linearGap=loose -psl \$psl $nibTargetDir $nibQueryDir \$chain" >> $bashFile
        echo "done" >> $bashFile
        echo "" >> $bashFile
        #--------------------------------------------------
        # qsub -q "all.q@compute-9-*,all.q@compute-8-2*" -o $lavCmdDir -N `basename $bashFile .sh` bash $bashFile
        #--------------------------------------------------
    done

    # pre chain
    if [ ! -e $netCmdDir ];  then mkdir $netCmdDir; fi
    echo '#!/bin/bash' > $netCmdDir/a.chainNet.sh
    echo "chainMergeSort -tempDir=$chainQueryDir/ $chainQueryDir/*.chain > $queryDir/$queryID.$targetID.all.chain" >> $netCmdDir/a.chainNet.sh
    echo "chainPreNet $queryDir/$queryID.$targetID.all.chain $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.pre.chain" >> $netCmdDir/a.chainNet.sh
    echo "chainNet $queryDir/$queryID.$targetID.pre.chain -minSpace=1 $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes stdout $queryDir/$queryID.$targetID.chainNet.err | netSyntenic stdin $queryDir/$queryID.$targetID.noClass.net" >> $netCmdDir/a.chainNet.sh
    echo "Run in hpc"
    echo "qsub -o $netCmdDir -N 'a.chainNet' bash $netCmdDir/a.chainNet.sh"

    # net
    echo 'cd $PBS_O_WORKDIR' > $netCmdDir/b.netClass.sh
    echo "netClass -noAr $queryDir/$queryID.$targetID.noClass.net $targetID $queryID $queryDir/$queryID.$targetID.net" >> $netCmdDir/b.netClass.sh
    echo "Run in gentoo"
    echo "qsub -o $netCmdDir -e $netCmdDir -j oe -N 'b.netClass' $netCmdDir/b.netClass.sh"

    #  maf
    echo '#!/bin/bash' > $netCmdDir/c.maf.sh
    echo "netToAxt $queryDir/$queryID.$targetID.net $queryDir/$queryID.$targetID.pre.chain $targetDir/$targetID.2bit $queryDir/$queryID.2bit stdout | axtSort stdin $queryDir/$queryID.$targetID.axt" >> $netCmdDir/c.maf.sh
    echo "axtToMaf $queryDir/$queryID.$targetID.axt $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.maf -tPrefix=$targetID. -qPrefix=$queryID." >> $netCmdDir/c.maf.sh
    echo "Run in hpc"
    echo "qsub -o $netCmdDir -N 'c.maf' bash $netCmdDir/c.maf.sh"
done
done
