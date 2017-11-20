#--------------------------------------------------
for speDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
# for dir in `ls -d batsGenome/eidHel`
#--------------------------------------------------
do
    genomic=`ls $speDir/*genomic.fna`
    id="`basename $speDir`1"
    if [ $id == "eidHel1" ]; then
        continue
    fi
    unDir="$speDir/$id.chrUn"
    chrDir="$speDir/$id.chrs1"
    trfDir="$speDir/$id.trf1"
    mskDir="$speDir/$id.mask1"
    lavDir="$speDir/$id.lav1"
    pslDir="$speDir/$id.psl1"
    chainDir="$speDir/$id.chain1"
    if [ ! -e $unDir ];  then mkdir $unDir; fi
    if [ ! -e $chrDir ];  then mkdir $chrDir; fi
    if [ ! -e $trfDir ];  then mkdir $trfDir; fi
    if [ ! -e $mskDir ];  then mkdir $mskDir; fi
    if [ ! -e $lavDir ];  then mkdir $lavDir; fi
    if [ ! -e $pslDir ];  then mkdir $pslDir; fi
    if [ ! -e $chainDir ];  then mkdir $chainDir; fi
    #--------------------------------------------------
    # python3 ./build_chrUn.py 100 $genomic $speDir/$id.chrUn $speDir/$id.chrUn.agp
    #--------------------------------------------------
    #--------------------------------------------------
    # cat $unDir/*.fa > $speDir/$id.fa
    #--------------------------------------------------
    fa="$speDir/$id.fa"
    faRename="$mskDir/$id.fa.masked.rename"
    echo $speDir
    echo $id
    echo $genomic
    echo $fa
    #--------------------------------------------------
    # qsub -N $id -pe smp 16 $HOME/software/src/RepeatMasker/RepeatMasker -pa 16 -s -norna -species mammal -dir $mskDir $fa
    #--------------------------------------------------
    #--------------------------------------------------
    # bioawk -c fastx -v id=$id '{print ">"id":"$name":1:+:"length($seq);print $seq}' $mskDir/$id.fa.masked > $faRename
    #--------------------------------------------------
    #--------------------------------------------------
    # awk -v id=$id '{printf "%s\t%d\t/synology/gbdb/%s/%s.2bit\n", $1, $2, id, id}' $dir/$id.chrom.sizes > $dir/$id.chromInfo.tab
    #--------------------------------------------------
    #--------------------------------------------------
    # grep '^>' $faRename | sed 's/>//' | awk -F ':' '{print $2, $0}' > $faRename.id
    # awk 'FNR==NR {a[$1]=$2; next} {$5=a[$5]; print}' $faRename.id $mskDir/$id.fa.out | sed '1,3d' > $mskDir/$id.fa.out.rename
    # cat batsGenome/eidHel/eidHel1.mask1/header $mskDir/$id.fa.out.rename > $mskDir/$id.fa.out.rename2
    #--------------------------------------------------
    #--------------------------------------------------
    #--------------------------------------------------
    # faSize $faRename -detailed > $speDir/$id.chrom.sizes
    #--------------------------------------------------
    # faSplit byName $faRename $chrDir/
    #--------------------------------------------------
    #--------------------------------------------------
    # qsub hgFakeAgp -minContigGap=1 $faRename $speDir/$id.fake.agp
    #--------------------------------------------------
    #--------------------------------------------------
    # qsub faToTwoBit $faRename $speDir/$id.2bit
    #--------------------------------------------------

    lavCmdDir="cmdLav"
    if [ ! -e $lavCmdDir ];  then mkdir $lavCmdDir; fi
    #--------------------------------------------------
    # for i in $chrDir/*.fa;
    # do
    #     curChr=`basename $i .fa`
    #     echo "#!/bin/bash"  > $lavCmdDir/$id.$curChr.sh
    #     echo "trfBig -bedAt=$trfDir/$curChr.bed -tempDir=$trfDir $i $trfDir/$curChr.fa" >> $lavCmdDir/$id.$curChr.sh
    #     echo "faToNib $trfDir/$curChr.fa $trfDir/$curChr.nib" >> $lavCmdDir/$id.$curChr.sh
    #     echo "for j in ucsc/hg38/hg38.trf1/*.nib; do lastz \$j $trfDir/$curChr.nib  --inner=2000 --ydrop=3400 --gappedthresh=6000 --hspthresh=2200 > $lavDir/\`basename \$j .nib\`-$curChr.nib.lav; done" >> $lavCmdDir/$id.$curChr.sh
    #     qsub -o $lavCmdDir -N `echo $id.$curChr | sed 's/:/-/g'` bash $lavCmdDir/$id.$curChr.sh
    # done
    #--------------------------------------------------
    #--------------------------------------------------
    # find $trfDir -name "*.bed" | xargs cat > $speDir/$id.simplerepeat.bed
    #--------------------------------------------------
    pslCmdDir="cmdPsl"
    if [ ! -e $pslCmdDir ];  then mkdir $pslCmdDir; fi
    #--------------------------------------------------
    # echo "#!/bin/bash"  > $pslCmdDir/$id.sh
    # for i in `find $lavDir -name *.lav`;
    # do
    #     psl=$pslDir/`basename $i .lav`.psl
    #     target=`basename $i .nib.lav | cut -d '-' -f1`
    #     query=`basename $i .nib.lav | cut -d '-' -f2`
    #     #--------------------------------------------------
    #     # echo "lavToPsl $i $psl" >> $pslCmdDir/$id.sh
    #     #--------------------------------------------------
    #     echo "axtChain -linearGap=loose -psl $psl -faT ./ucsc/hg38/hg38.trf1/$target.fa -faQ $trfDir/$query.fa $chainDir/`basename $i .lav`.chain" >> $pslCmdDir/$id.sh
    # done
    # echo "chainMergeSort $chainDir/*.chain > $speDir/$id.all.chain" >> $pslCmdDir/$id.sh
    # echo "chainPreNet $speDir/$id.all.chain ucsc/hg38/hg38.chrom.sizes $speDir/$id.chrom.sizes $speDir/$id.pre.chain" >> $pslCmdDir/$id.sh
    # echo "chainNet $speDir/$id.pre.chain -minSpace=1 ucsc/hg38/hg38.chrom.sizes $speDir/$id.chrom.sizes stdout $speDir/$id.chainNet.err | netSyntenic stdin $speDir/$id.noClass.net" >> $pslCmdDir/$id.sh
    # qsub -o $pslCmdDir -N $id bash $pslCmdDir/$id.sh
    #--------------------------------------------------
    # echo 'cd $PBS_O_WORKDIR' > $pslCmdDir/$id.netClass.sh
    # echo "netClass -noAr $speDir/$id.noClass.net hg38 $id $speDir/$id.net" >> $pslCmdDir/$id.netClass.sh
    #--------------------------------------------------
    qsub -o $pslCmdDir -e $pslCmdDir -j oe -N $id $pslCmdDir/$id.netClass.sh

    #--------------------------------------------------
    # echo '#!/bin/bash' > $pslCmdDir/$id.maf.sh
    # echo "netToAxt $speDir/$id.net $speDir/$id.pre.chain ucsc/hg38/hg38.2bit $speDir/$id.2bit stdout | axtSort stdin $speDir/hg38-$id.axt" >> $pslCmdDir/$id.maf.sh
    # echo "axtToMaf $speDir/hg38-$id.axt ucsc/hg38/hg38.chrom.sizes $speDir/$id.chrom.sizes $speDir/hg38-$id.maf -tPrefix=hg38. -qPrefix=$id." >> $pslCmdDir/$id.maf.sh
    #--------------------------------------------------
    #--------------------------------------------------
    # qsub -o $pslCmdDir -N $id bash $pslCmdDir/$id.maf.sh
    #--------------------------------------------------

    #--------------------------------------------------
    # mafCmdDir="cmdMaf"
    # if [ ! -e $mafCmdDir ];  then mkdir $mafCmdDir; fi
    # echo "#!/bin/bash"  > $mafCmdDir/$id.sh
    #--------------------------------------------------
done
