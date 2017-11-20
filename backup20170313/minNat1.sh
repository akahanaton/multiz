faSplit byName batsGenome/minNat/minNat1.mask1/minNat1.fa.masked batsGenome/minNat/minNat1.chrs1/
for i in `find batsGenome/minNat/minNat1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/minNat/minNat1.trf1/$curChr.bed -tempDir=batsGenome/minNat/minNat1.trf1 $i batsGenome/minNat/minNat1.trf1/$curChr.fa
faToNib batsGenome/minNat/minNat1.trf1/$curChr.fa batsGenome/minNat/minNat1.nib1/$curChr.nib
done
