#!/bin/bash
cd $PBS_O_WORKDIR
fa=./batsGenome/eonSpe/GCF_20170106.fa
id=`basename $dir`
curDir=`dirname $(dirname $fa)`
chrDir="$dir/$id.chrs"
trfDir="$dir/$id.trf"
mskDir="$dir/$id.mask"
lavDir="$dir/$id.lav"

mkdir $mskDir
/LinuxData/software/src/RepeatMasker/RepeatMasker -pa 45 -s -norna -species mammal -dir $mskDir $fa

code=`basename $dir`
echo $dir
echo $code
mkdir $dir/$code.chrs
./build_chrUn.py 100 $fa $dir/$code.chrs $dir/$code.agp

hgFakeAgp -minContigGap=1 newGenome.fa eidHel1.fake.agp
faToTwoBit newGenome.fa eidHel1.2bit
mkdir /gbdb/eidHel1
mkdir /gbdb/eidHel1/html
ln -s `pwd`/eidHel1.2bit /gbdb/eidHel1/eidHel1.2bit
#sort -k1,1 -k2n,2n original.agp > eidHel1.agp
checkAgpAndFa eidHel1.agp eidHel1.2bit
twoBitInfo eidHel1.2bit stdout | sort -k2nr > chrom.sizes
awk '{printf "%s\t%d\t/synology/gbdb/eidHel1/eidHel1.2bit\n", $1, $2}' chrom.sizes > chromInfo.tab

hgsql -e "create database eidHel1;"
hgsql -u root -p -e "create database eidHel1;"
hgsql -u root -p eidHel1 < /home/gmswenm/software/src/kentUtils/src/hg/lib/grp.sql
hgLoadSqlTab eidHel1 chromInfo $HOME/software/src/kentUtils/src/hg/lib/chromInfo.sql chromInfo.tab
hgGoldGapGl eidHel1 eidHel1.fake.agp
hgLoadBed eidHel1 simpleRepeat batsGenome/eidHel/eidHel1.simplerepeat.bed -sqlTable=./kentUtils/src/hg/lib/simpleRepeat.sql

#cd bed/gc5Base
hgGcPercent -wigOut -doGaps -file=stdout -win=5 -verbose=0 eidHel1 ../../eidHel1.2bit | wigEncode stdin gc5Base.{wig,wib}
hgLoadWiggle -pathPrefix=/gbdb/eidHel1/wib eidHel1 gc5Base gc5Base.wig
mkdir /gbdb/eidHel1/wib
ln -s `pwd`/gc5Base.wib /gbdb/eidHel1/wib

#--------------------------------------------------
# 12. Create defaultDb and genomeClade table SQL entries. For example:
#--------------------------------------------------
hgsql hgcentral -e 'INSERT INTO defaultDb (genome, name) VALUES ("A. organism", "eidHel1");'
hgsql hgcentral -e 'INSERT INTO genomeClade (genome, clade, priority) VALUES ("A. organism", "vertebrate", 123);'

#--------------------------------------------------
# 13. verify the hgcentral table relationships with a join command on these tables:
#--------------------------------------------------
hgsql -e "SELECT d.name,d.orderKey,g.genome,g.priority,g.clade,d.scientificName FROM
dbDb d, genomeClade g
WHERE d.organism = g.genome
ORDER by d.orderKey;" hgcentral
