#--------------------------------------------------
# for queryDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
#--------------------------------------------------
# for queryDir in `ls -d batsGenome/eonSpe batsGenome/pteAle`
#--------------------------------------------------
for queryDir in `cat ./batsGenome.list`
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
for targetDir in `ls -d batsGenome/eonSpe batsGenome/pteAle ucsc/hg38`
do
    targetID=`basename $targetDir`
    #--------------------------------------------------
    # lastzPara="--inner=2000 --ydrop=9400 --gappedthresh=3000 --hspthresh=3000 --notransition --step=4 --scores=HaploMerger_20120810/project_template/scoreMatrix.q"
    #--------------------------------------------------
    lastzPara="M=40 K=3000 L=3000 Y=9400 E=30 H=0 O=400 T=1"
    if [ $targetID != "hg38" ]; then
        targetID=$targetID"1"
        lastzPara="M=40 K=3000 L=3000 Y=9400 E=30 H=0 O=400 T=1"
    fi
    #--------------------------------------------------
    # ls $queryDir/$genomic
    #--------------------------------------------------
    if [[ $queryID == $targetID || $queryDone == *"$targetID"* ]]; then
        continue
    fi
    echo $queryID.vs.$targetID

    nibTargetDir="$targetDir/$targetID.nib1"

    lavOutDir="$queryDir/$queryID.$targetID.lav2"
    pslOutDir="$queryDir/$queryID.$targetID.psl2"
    chainOutDir="$queryDir/$queryID.$targetID.chain2"
    lavCmdOutDir="cmdLav2.$queryID.$targetID"
    netCmdOutDir="cmdNet2.$queryID.$targetID"
    rm -rf $lavCmdDir
    if [ ! -e $lavCmdOutDir ];  then mkdir $lavCmdOutDir; fi
    if [ ! -e $netCmdOutDir ];  then mkdir $netCmdOutDir; fi
    if [ ! -e $lavOutDir ];  then mkdir $lavOutDir; fi
    if [ ! -e $pslOutDir ];  then mkdir $pslOutDir; fi
    if [ ! -e $chainOutDir ];  then mkdir $chainOutDir; fi

    # 18 lines
    for queryNib in $nibQueryDir/*.nib
    do
        queryChr=`basename $queryNib .nib`
        bashFile=$lavCmdOutDir/$queryID.$targetID.$queryChr.sh
        echo "#!/bin/bash" > $bashFile
        echo "for targetNib in $nibTargetDir/*.nib; do" >> $bashFile
        echo "    targetChr=\`basename \$targetNib .nib\`;" >> $bashFile
        echo "    lav=$lavOutDir/$queryID.$targetID.$queryChr.\$targetChr.lav" >> $bashFile
        echo "    psl=\`echo \$lav | sed 's/lav/psl/g'\`" >> $bashFile
        echo "    chain=\`echo \$lav | sed 's/lav/chain/g'\`" >> $bashFile
        echo "    lastz \$targetNib $queryNib $lastzPara > \$lav;" >> $bashFile
        echo '    lavToPsl $lav $psl' >> $bashFile
        echo "    axtChain -linearGap=loose -psl \$psl $nibTargetDir $nibQueryDir \$chain" >> $bashFile
        echo "done" >> $bashFile
        echo "" >> $bashFile
        qsub -q "all.q@compute-9-*,all.q@compute-8-2*" -o $lavCmdOutDir -N `basename $bashFile .sh` bash $bashFile
    done

    # pre chain
    if [ ! -e $netCmdOutDir ];  then mkdir $netCmdOutDir; fi
    echo '#!/bin/bash' > $netCmdOutDir/a.chainNet.sh
    echo "chainMergeSort -tempDir=$chainOutDir/ $chainOutDir/*.chain > $queryDir/$queryID.$targetID.all.chain2" >> $netCmdOutDir/a.chainNet.sh
    echo "chainPreNet $queryDir/$queryID.$targetID.all.chain2 $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.pre.chain2" >> $netCmdOutDir/a.chainNet.sh
    echo "chainNet $queryDir/$queryID.$targetID.pre.chain2 -minSpace=1 $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes stdout $queryDir/$queryID.$targetID.chainNet.err2 | netSyntenic stdin $queryDir/$queryID.$targetID.noClass.net2" >> $netCmdOutDir/a.chainNet.sh
    echo "Run in hpc"
    echo "    qsub -o $netCmdOutDir -N 'a.chainNet' bash $netCmdOutDir/a.chainNet.sh"

    # net
    echo 'cd $PBS_O_WORKDIR' > $netCmdOutDir/b.netClass.sh
    echo "netClass -noAr $queryDir/$queryID.$targetID.noClass.net2 $targetID $queryID $queryDir/$queryID.$targetID.net2" >> $netCmdOutDir/b.netClass.sh
    echo "Run in gentoo"
    echo "    qsub -o $netCmdOutDir -e $netCmdOutDir -j oe -N 'b.netClass' $netCmdOutDir/b.netClass.sh"

    #  maf
    echo '#!/bin/bash' > $netCmdOutDir/c.maf.sh
    echo "netToAxt $queryDir/$queryID.$targetID.net2 $queryDir/$queryID.$targetID.pre.chain2 $targetDir/$targetID.2bit $queryDir/$queryID.2bit stdout | axtSort stdin $queryDir/$queryID.$targetID.axt2" >> $netCmdOutDir/c.maf.sh
    echo "axtToMaf $queryDir/$queryID.$targetID.axt2 $targetDir/$targetID.chrom.sizes $queryDir/$queryID.chrom.sizes $queryDir/$queryID.$targetID.maf2 -tPrefix=$targetID. -qPrefix=$queryID." >> $netCmdOutDir/c.maf.sh
    echo "Run in hpc"
    echo "    qsub -o $netCmdOutDir -N 'c.maf' bash $netCmdOutDir/c.maf.sh"
    echo ""
done
done
