faSplit byName batsGenome/rhiFer/rhiFer1.mask1/rhiFer1.fa.masked batsGenome/rhiFer/rhiFer1.chrs1/
for i in `find batsGenome/rhiFer/rhiFer1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/rhiFer/rhiFer1.trf1/$curChr.bed -tempDir=batsGenome/rhiFer/rhiFer1.trf1 $i batsGenome/rhiFer/rhiFer1.trf1/$curChr.fa
faToNib batsGenome/rhiFer/rhiFer1.trf1/$curChr.fa batsGenome/rhiFer/rhiFer1.nib1/$curChr.nib
done
