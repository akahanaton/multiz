faSplit byName batsGenome/eptFus/eptFus1.mask1/eptFus1.fa.masked batsGenome/eptFus/eptFus1.chrs1/
for i in `find batsGenome/eptFus/eptFus1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/eptFus/eptFus1.trf1/$curChr.bed -tempDir=batsGenome/eptFus/eptFus1.trf1 $i batsGenome/eptFus/eptFus1.trf1/$curChr.fa
faToNib batsGenome/eptFus/eptFus1.trf1/$curChr.fa batsGenome/eptFus/eptFus1.nib1/$curChr.nib
done
