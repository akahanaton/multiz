faSplit byName batsGenome/myoLuc/myoLuc1.mask1/myoLuc1.fa.masked batsGenome/myoLuc/myoLuc1.chrs1/
for i in `find batsGenome/myoLuc/myoLuc1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/myoLuc/myoLuc1.trf1/$curChr.bed -tempDir=batsGenome/myoLuc/myoLuc1.trf1 $i batsGenome/myoLuc/myoLuc1.trf1/$curChr.fa
faToNib batsGenome/myoLuc/myoLuc1.trf1/$curChr.fa batsGenome/myoLuc/myoLuc1.nib1/$curChr.nib
done
