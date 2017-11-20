faSplit byName batsGenome/rouAeg/rouAeg1.mask1/rouAeg1.fa.masked batsGenome/rouAeg/rouAeg1.chrs1/
for i in `find batsGenome/rouAeg/rouAeg1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/rouAeg/rouAeg1.trf1/$curChr.bed -tempDir=batsGenome/rouAeg/rouAeg1.trf1 $i batsGenome/rouAeg/rouAeg1.trf1/$curChr.fa
faToNib batsGenome/rouAeg/rouAeg1.trf1/$curChr.fa batsGenome/rouAeg/rouAeg1.nib1/$curChr.nib
done
