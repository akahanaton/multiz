for speDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
# for speDir in `ls -d batsGenome/eonSpe`
#--------------------------------------------------
do
    id="`basename $speDir`1"
    genomic=`basename $speDir/$id.fa`
    # if [ $id == "eidHel2" ]; then
    #     continue
    # fi
    #--------------------------------------------------
    mskDir="$speDir/$id.mask1"
    chrDir="$speDir/$id.chrs1"
    trfDir="$speDir/$id.trf1"
    nibDir="$speDir/$id.nib1"
    lavDir="$speDir/$id.lav1"
    pslDir="$speDir/$id.psl1"
    chainDir="$speDir/$id.chain1"
    #--------------------------------------------------
    # rm -rf $chrDir $trfDir $nibDir $lavDir $pslDir $chainDir
    #--------------------------------------------------
    if [ ! -e $chrDir ];  then mkdir $chrDir; fi
    if [ ! -e $trfDir ];  then mkdir $trfDir; fi
    if [ ! -e $nibDir ];  then mkdir $nibDir; fi
    if [ ! -e $mskDir ];  then mkdir $mskDir; fi
    if [ ! -e $lavDir ];  then mkdir $lavDir; fi
    if [ ! -e $pslDir ];  then mkdir $pslDir; fi
    if [ ! -e $chainDir ];  then mkdir $chainDir; fi

    maskedGenomic=`ls $mskDir/$genomic.masked`

    # qsub -N $id -pe smp 16 $HOME/software/src/RepeatMasker/RepeatMasker -pa 16 -s -norna -species mammal -dir $mskDir $speDir/$genomic

    # prepare mysql tables
    #--------------------------------------------------
    # faSize $maskedGenomic -detailed > $speDir/$id.chrom.sizes
    # faSplit byName $maskedGenomic $chrDir/
    #--------------------------------------------------
    echo "faSplit byName $maskedGenomic $chrDir/" > $id.sh
    #--------------------------------------------------
    # awk -v id=$id '{printf "%s\t%d\t/synology/gbdb/%s/%s.2bit\n", $1, $2, id, id}' $speDir/$id.chrom.sizes > $speDir/$id.chromInfo.tab
    # hgFakeAgp -minContigGap=1 $maskedGenomic $speDir/$id.fake.agp
    # faToTwoBit $maskedGenomic $speDir/$id.2bit
    #--------------------------------------------------
    echo "for i in \`find $chrDir -name '*.fa'\`" >> $id.sh
    echo "do" >> $id.sh
    echo "curChr=\`basename \$i .fa\`" >> $id.sh
    echo "trfBig -bedAt=$trfDir/\$curChr.bed -tempDir=$trfDir \$i $trfDir/\$curChr.fa" >> $id.sh
    echo "faToNib $trfDir/\$curChr.fa $nibDir/\$curChr.nib" >> $id.sh
    echo "done" >> $id.sh
    #--------------------------------------------------
    # find $trfDir -name "*.bed" | xargs cat > $speDir/$id.simplerepeat.bed
    #--------------------------------------------------

    # load into mysql
    #--------------------------------------------------
    # mkdir /synology/gbdb/$id
    # faToTwoBit $speDir/$genomic /synology/gbdb/$id/$id.2bit
    # hgsql -e "create database $id;"
    # hgsql $id < /home/gmswenm/software/src/kentUtils/src/hg/lib/grp.sql
    #--------------------------------------------------

    #--------------------------------------------------
    # echo "hgLoadSqlTab $id chromInfo $HOME/software/src/kentUtils/src/hg/lib/chromInfo.sql $speDir/$id.chromInfo.tab"
    # hgLoadSqlTab $id chromInfo $HOME/software/src/kentUtils/src/hg/lib/chromInfo.sql $speDir/$id.chromInfo.tab
    # hgGoldGapGl $id $speDir/$id.fake.agp
    # hgLoadBed $id simpleRepeat $speDir/$id.simplerepeat.bed -sqlTable=./kentUtils/src/hg/lib/simpleRepeat.sql
    # hgLoadOut $id $mskDir/$genomic.out
    #--------------------------------------------------
done
