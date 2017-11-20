for speDir in ./ucsc/hg38
do
    genomic=`ls $speDir/*genomic.fna`
    id="`basename $speDir`"
    #--------------------------------------------------
    # if [ $id == "eidHel1" ]; then
    #     continue
    # fi
    #--------------------------------------------------
    unDir="$speDir/$id.chrUn"
    chrDir="$speDir/$id.chrs1"
    trfDir="$speDir/$id.trf1"
    mskDir="$speDir/$id.mask1"
    lavDir="$speDir/$id.lav1"
    if [ ! -e $unDir ];  then mkdir $unDir; fi
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
    #--------------------------------------------------
    # faSplit byName $mskDir/$id.fa.masked.rename $chrDir/
    #--------------------------------------------------
    for i in $chrDir/*.fa;
    do
        curChr=`basename $i .fa`

        echo "#!/bin/bash"  > cmd/$id.$curChr.cmd
        #--------------------------------------------------
        # echo "trfBig -bedAt=$trfDir/$curChr.bed -tempDir=$trfDir $i $trfDir/$curChr.fa" > cmd/$id.$curChr.cmd
        #--------------------------------------------------
        echo "faToNib $trfDir/$curChr.fa $trfDir/$curChr.nib" >> cmd/$id.$curChr.cmd
        qsub -o cmd -N `echo $id.$curChr | sed 's/:/-/g'` bash cmd/$id.$curChr.cmd
    done
done
