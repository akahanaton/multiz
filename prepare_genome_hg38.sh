for speDir in ./ucsc/hg38
do
    genomic=`ls $speDir/*genomic.fna`
    id="`basename $speDir`"
    chrDir="$speDir/$id.chrs2"
    trfDir="$speDir/$id.trf2"
    mskDir="$speDir/$id.mask2"
    if [ ! -e $chrDir ];  then mkdir $chrDir; fi
    if [ ! -e $trfDir ];  then mkdir $trfDir; fi
    if [ ! -e $mskDir ];  then mkdir $mskDir; fi
    if [ ! -e $lavDir ];  then mkdir $lavDir; fi
    if [ -e lastz.$id.cmd ];  then rm lastz.$id.cmd; fi
    fa="$speDir/$id.fa"
    echo $speDir
    echo $id
    echo $genomic
    echo $fa
    #--------------------------------------------------
    # qsub -N $id -pe smp 16 $HOME/software/src/RepeatMasker/RepeatMasker -pa 16 -s -norna -species mammal -dir $mskDir $fa
    #--------------------------------------------------
    #--------------------------------------------------
    # bioawk -c fastx -v id=$id '{print ">"id":"$name":1:+:"length($seq);print $seq}' $mskDir/$id.fa.masked > $mskDir/$id.fa.masked.rename
    #--------------------------------------------------
    # faSize $mskDir/$id.fa.masked.rename -detailed > $speDir/$id.chrom.sizes
    faSplit byName $mskDir/$id.fa.masked $chrDir/
    for i in $chrDir/*.fa;
    do
        curChr=`basename $i .fa`

        echo "#!/bin/bash"  > cmd/$id.$curChr.cmd
        echo "trfBig -bedAt=$trfDir/$curChr.bed -tempDir=$trfDir $i $trfDir/$curChr.fa" > cmd/$id.$curChr.cmd
        echo "faToNib $trfDir/$curChr.fa $trfDir/$curChr.nib" >> cmd/$id.$curChr.cmd
        qsub -o cmd -N `echo $id.$curChr | sed 's/:/-/g'` bash cmd/$id.$curChr.cmd
    done
    faSize $mskDir/$id.fa.masked -detailed > $speDir/$id.chrom.sizes
    faToTwoBit $mskDir/$id.fa.masked $speDir/$id.2bit
done
