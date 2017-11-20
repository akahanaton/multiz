faSplit byName batsGenome/ptePar/ptePar1.mask1/ptePar1.fa.masked batsGenome/ptePar/ptePar1.chrs1/
for i in `find batsGenome/ptePar/ptePar1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/ptePar/ptePar1.trf1/$curChr.bed -tempDir=batsGenome/ptePar/ptePar1.trf1 $i batsGenome/ptePar/ptePar1.trf1/$curChr.fa
faToNib batsGenome/ptePar/ptePar1.trf1/$curChr.fa batsGenome/ptePar/ptePar1.nib1/$curChr.nib
done
