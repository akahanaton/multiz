faSplit byName batsGenome/eonSpe/eonSpe1.mask1/eonSpe1.fa.masked batsGenome/eonSpe/eonSpe1.chrs1/
for i in `find batsGenome/eonSpe/eonSpe1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/eonSpe/eonSpe1.trf1/$curChr.bed -tempDir=batsGenome/eonSpe/eonSpe1.trf1 $i batsGenome/eonSpe/eonSpe1.trf1/$curChr.fa
faToNib batsGenome/eonSpe/eonSpe1.trf1/$curChr.fa batsGenome/eonSpe/eonSpe1.nib1/$curChr.nib
done
