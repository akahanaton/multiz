faSplit byName batsGenome/eidHel/eidHel1.mask1/eidHel1.fa.masked batsGenome/eidHel/eidHel1.chrs1/
for i in `find batsGenome/eidHel/eidHel1.chrs1 -name '*.fa'`
do
curChr=`basename $i .fa`
trfBig -bedAt=batsGenome/eidHel/eidHel1.trf1/$curChr.bed -tempDir=batsGenome/eidHel/eidHel1.trf1 $i batsGenome/eidHel/eidHel1.trf1/$curChr.fa
faToNib batsGenome/eidHel/eidHel1.trf1/$curChr.fa batsGenome/eidHel/eidHel1.nib1/$curChr.nib
done
