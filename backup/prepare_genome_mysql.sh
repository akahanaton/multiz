for dir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
do
    id="`basename $dir`1"

    if [ $id == "eidHel1" ]; then
        continue;
    fi
    #--------------------------------------------------
    # hgsql -e "create database $id;"
    # hgsql $id < /home/gmswenm/software/src/kentUtils/src/hg/lib/grp.sql
    #--------------------------------------------------
    echo $id

    fa=$dir/$id.mask1/$id.fa.masked.rename

    #--------------------------------------------------
    # mkdir /synology/gbdb/$id
    # faToTwoBit $fa /synology/gbdb/$id/$id.2bit
    # twoBitInfo $dir/$id.2bit stdout | sort -k2nr > $dir/$id.chrom.sizes
    #--------------------------------------------------
    # echo "hgLoadSqlTab $id chromInfo $HOME/software/src/kentUtils/src/hg/lib/chromInfo.sql $dir/$id.chromInfo.tab"
    # hgLoadSqlTab $id chromInfo $HOME/software/src/kentUtils/src/hg/lib/chromInfo.sql $dir/$id.chromInfo.tab
    #--------------------------------------------------
    #--------------------------------------------------
    # hgGoldGapGl $id $dir/$id.fake.agp
    #--------------------------------------------------
    #--------------------------------------------------
    # hgLoadBed $id simpleRepeat $dir/$id.simplerepeat.bed -sqlTable=./kentUtils/src/hg/lib/simpleRepeat.sql
    #--------------------------------------------------
    hgLoadOut $id $dir/$id.mask1/$id.fa.out.rename2
done
