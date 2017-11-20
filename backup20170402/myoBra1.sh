faSplit byName batsGenome/myoBra/myoBra1.mask1/myoBra1.fa.masked batsGenome/myoBra/myoBra1.chrs1/
for i in `find batsGenome/myoBra/myoBra1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/myoBra/myoBra1.trf1/$curChr.bed -tempDir=batsGenome/myoBra/myoBra1.trf1 $i batsGenome/myoBra/myoBra1.trf1/$curChr.fa
faToNib batsGenome/myoBra/myoBra1.trf1/$curChr.fa batsGenome/myoBra/myoBra1.nib1/$curChr.nib
done
