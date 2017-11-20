faSplit byName batsGenome/pteVam/pteVam1.mask1/pteVam1.fa.masked batsGenome/pteVam/pteVam1.chrs1/
for i in `find batsGenome/pteVam/pteVam1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/pteVam/pteVam1.trf1/$curChr.bed -tempDir=batsGenome/pteVam/pteVam1.trf1 $i batsGenome/pteVam/pteVam1.trf1/$curChr.fa
faToNib batsGenome/pteVam/pteVam1.trf1/$curChr.fa batsGenome/pteVam/pteVam1.nib1/$curChr.nib
done
