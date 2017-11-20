#--------------------------------------------------
# for dir in ./ucsc/homSap
#--------------------------------------------------
#--------------------------------------------------
# for dir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
for dir in ./batsGenome/eidHel ./batsGenome/eonSpe
do
    genomic=`ls $dir/*genomic.fna`
    id="`basename $dir`1"
    fa="$dir/$id.fa"
    fna="$dir/$id.fna"
    unDir="$dir/$id.chrUn"
    chrDir="$dir/$id.chrs2"
    trfDir="$dir/$id.trf2"
    mskDir="$dir/$id.mask2"
    lavDir="$dir/$id.lav2"
    if [ ! -e $unDir ];  then mkdir $unDir; fi
    if [ ! -e $chrDir ];  then mkdir $chrDir; fi
    if [ ! -e $trfDir ];  then mkdir $trfDir; fi
    if [ ! -e $mskDir ];  then mkdir $mskDir; fi
    if [ ! -e $lavDir ];  then mkdir $lavDir; fi
    if [ -e lastz.$id.cmd2 ];  then rm lastz.cmd2; fi
    #--------------------------------------------------
    # bioawk -c fastx -v id=$id '{print ">"id":"$name":1:+:"length($seq);print $seq}' $genomic > $fna
    #--------------------------------------------------
    echo $dir
    echo $id
    echo $genomic
    echo $fa
    #--------------------------------------------------
    # qsub -N $id -pe smp 16 $HOME/software/src/RepeatMasker/RepeatMasker -pa 16 -s -norna -species mammal -dir $mskDir $fna
    #--------------------------------------------------
    #--------------------------------------------------
    # qsub -N $id -pe smp 16 $HOME/software/src/RepeatMasker/RepeatMasker -pa 16 -s -norna -species human -dir $mskDir $fna
    #--------------------------------------------------
    rm -rf $chrDir
    rm -rf $trfDir
    #--------------------------------------------------
    # faSplit byName $mskDir/*.masked $chrDir/
    #--------------------------------------------------
    #--------------------------------------------------
    # for i in $chrDir/*.fa; do qsub trfBig -bedAt=$trfDir/`basename $i .fa`.bed -tempDir=$trfDir $i $trfDir/`basename $i`; done
    #--------------------------------------------------
    #--------------------------------------------------
    # for i in $trfDir/*.fa; do qsub faToNib $i `echo $i | sed -e s/.fa/.nib/`; done
    #--------------------------------------------------

    # perform lastz alignment
    if [ -e $trfDir ]; then
        echo "#!/bin/bash"  >> lastz.$id.cmd2
        # echo 'cd $PBS_O_WORKDIR'
        #--------------------------------------------------
        # for i in $trfDir/*.nib; do echo "for j in ucsc/homSap/homSap1.trf1/*.nib; do lastz \$j $i  --inner=2000 --ydrop=3400 --gappedthresh=6000 --hspthresh=2200 --scores=HoxD55.q > $lavDir/\`basename \$j .nib\`-\`basename $i .nib\`.lav; done"; done
        #--------------------------------------------------
        for i in $trfDir/*.nib; do echo "for j in ucsc/homSap/homSap1.trf2/*.nib; do lastz \$j $i  --inner=2000 --ydrop=3400 --gappedthresh=6000 --hspthresh=2200 > $lavDir/\`basename \$j .nib\`-\`basename $i .nib\`.lav; done"; done >> lastz.$id.cmd2
    fi
    #--------------------------------------------------
    # csplit ./lastz.cmd /bash/ {*} -s -f lastz -n2 -b "%02d.qsub" && rm lastz00.qsub
    # chmod a+x lastz*.qsub
    # for cmd in lastz*.qsub; do qsub $cmd; done
    #--------------------------------------------------
done

#--------------------------------------------------
# 
# axtChain all.psl  homSap/homSap.trf eidHel.trf/ eidHel.chain/all.chain  -linearGap=loose -psl
# chainPreNet eidHel.chain/all.chain homSap/homSap.chrom.sizes eidHel.chrom.sizes all.pre.chain
# chainNet all.pre.chain -minSpace=1 homSap/homSap.chrom.sizes eidHel.chrom.sizes stdout eee | netSyntenic stdin noClass.net
# netClass -noAr noClass.net hg38 eidHel cioSav2.net
#--------------------------------------------------
