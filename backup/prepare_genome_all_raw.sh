#--------------------------------------------------
for speDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
# for dir in `ls -d batsGenome/eidHel`
#--------------------------------------------------
do
    echo $speDir
    genomic=`basename $speDir/*genomic.fa`
    ls $speDir/$genomic
    id="`basename $speDir`2"
    if [ $id == "eidHel2" ]; then
        continue
    fi
    mskDir="$speDir/$genomic.mask"
    chrDir="$speDir/$id.chrs2"
    trfDir="$speDir/$id.trf2"
    lavDir="$speDir/$id.lav2"
    pslDir="$speDir/$id.psl2"
    chainDir="$speDir/$id.chain2"
    if [ ! -e $chrDir ];  then mkdir $chrDir; fi
    if [ ! -e $trfDir ];  then mkdir $trfDir; fi
    if [ ! -e $mskDir ];  then mkdir $mskDir; fi
    if [ ! -e $lavDir ];  then mkdir $lavDir; fi
    if [ ! -e $pslDir ];  then mkdir $pslDir; fi
    if [ ! -e $chainDir ];  then mkdir $chainDir; fi
    # qsub -N $id -pe smp 16 $HOME/software/src/RepeatMasker/RepeatMasker -pa 16 -s -norna -species mammal -dir $mskDir $fa
    #--------------------------------------------------
    # python3 ./seprate_fasta.py 100 $mskDir/$genomic.masked $chrDir
    #--------------------------------------------------
    # awk -v id=$id '{printf "%s\t%d\t/synology/gbdb/%s/%s.2bit\n", $1, $2, id, id}' $speDir/$id.chrom.sizes > $speDir/$id.chromInfo.tab
    # faSize $genomic -detailed > $speDir/$id.chrom.sizes
    #--------------------------------------------------
    #--------------------------------------------------
    # qsub hgFakeAgp -minContigGap=1 $faRename $speDir/$id.fake.agp
    #--------------------------------------------------
    #--------------------------------------------------
    # qsub faToTwoBit $faRename $speDir/$id.2bit
    #--------------------------------------------------

done
