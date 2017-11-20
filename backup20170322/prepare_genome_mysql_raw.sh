#--------------------------------------------------
# for speDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
#--------------------------------------------------
for speDir in `ls -d batsGenome2/eonSpe`
#--------------------------------------------------
# for speDir in `ls -d batsGenome/eidHel`
#--------------------------------------------------
do
    echo $speDir
    genomic=`basename $speDir/*genomic.fa`
    ls $speDir/$genomic
    id=`basename $speDir`2
    echo $id
    #--------------------------------------------------
    # if [ $id == "eidHel2" ]; then
    #     continue
    # fi
    #--------------------------------------------------
    #--------------------------------------------------
    # maskDir="$speDir/$genomic.mask"
    #--------------------------------------------------
    maskDir="$speDir/$id.mask2"
    chrDir="$speDir/$id.chrs2"
    trfDir="$speDir/$id.trf2"
    nibDir="$speDir/$id.nib2"

    # link $maskDir/$id.fa.masked $maskDir/$id.fa.out $maskDir/$id.fa

    if [ ! -e $chrDir ];  then mkdir $chrDir; fi
    if [ ! -e $trfDir ];  then mkdir $trfDir; fi
    if [ ! -e $nibDir ];  then mkdir $nibDir; fi

    ls -f $trfDir | wc -l
    ls -f $nibDir | wc -l
    ls -f $chrDir | wc -l

    maskedGenomic=`ls $maskDir/$id.fa.masked`
    #--------------------------------------------------
    # # qsub -N $id -pe smp 16 $HOME/software/src/RepeatMasker/RepeatMasker -pa 16 -s -norna -species mammal -dir $maskDir $fa
    #--------------------------------------------------
    #--------------------------------------------------
    # faSize $maskedGenomic -detailed > $speDir/$id.chrom.sizes
    # awk -v id=$id '{printf "%s\t%d\t/synology/gbdb/%s/%s.2bit\n", $1, $2, id, id}' $speDir/$id.chrom.sizes > $speDir/$id.chromInfo.tab
    # hgFakeAgp -minContigGap=1 $maskedGenomic $speDir/$id.fake.agp
    # faSplit byName $maskedGenomic $chrDir/
    #--------------------------------------------------
    #--------------------------------------------------
    # faToTwoBit $maskedGenomic $speDir/$id.2bit
    #--------------------------------------------------
    #--------------------------------------------------
    # faToTwoBit $maskDir/$id.fa $speDir/$id.2bit
    # for i in `find $chrDir -name "*.fa"`
    # do
    #     curChr=`basename $i .fa`
    #     trfBig -bedAt=$trfDir/$curChr.bed -tempDir=$trfDir $i $trfDir/$curChr.fa
    #     faToNib $trfDir/$curChr.fa $nibDir/$curChr.nib
    # done
    # find $trfDir/ -name "*.bed" | xargs cat > $speDir/$id.simplerepeat.bed
    #--------------------------------------------------

    # run on gentoo
    mkdir /synology/gbdb/$id
    mkdir /synology/gbdb/$id/html
    faToTwoBit $maskDir/$id.fa /synology/gbdb/$id/$id.2bit
    hgsql -e "create database $id;"
    hgsql $id < /home/gmswenm/software/src/kentUtils/src/hg/lib/grp.sql
    hgLoadSqlTab $id chromInfo $HOME/software/src/kentUtils/src/hg/lib/chromInfo.sql $speDir/$id.chromInfo.tab
    hgGoldGapGl $id $speDir/$id.fake.agp
    hgLoadBed $id simpleRepeat $speDir/$id.simplerepeat.bed -sqlTable=./kentUtils/src/hg/lib/simpleRepeat.sql
    hgLoadOut $id $maskDir/$id.fa.out
done
