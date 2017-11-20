faSplit byName batsGenome/pteAle/pteAle1.mask1/pteAle1.fa.masked batsGenome/pteAle/pteAle1.chrs1/
for i in `find batsGenome/pteAle/pteAle1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/pteAle/pteAle1.trf1/$curChr.bed -tempDir=batsGenome/pteAle/pteAle1.trf1 $i batsGenome/pteAle/pteAle1.trf1/$curChr.fa
faToNib batsGenome/pteAle/pteAle1.trf1/$curChr.fa batsGenome/pteAle/pteAle1.nib1/$curChr.nib
done
