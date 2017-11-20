faSplit byName batsGenome/megLyr/megLyr1.mask1/megLyr1.fa.masked batsGenome/megLyr/megLyr1.chrs1/
for i in `find batsGenome/megLyr/megLyr1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/megLyr/megLyr1.trf1/$curChr.bed -tempDir=batsGenome/megLyr/megLyr1.trf1 $i batsGenome/megLyr/megLyr1.trf1/$curChr.fa
faToNib batsGenome/megLyr/megLyr1.trf1/$curChr.fa batsGenome/megLyr/megLyr1.nib1/$curChr.nib
done
