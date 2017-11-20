#!/bin/bash
cd $PBS_O_WORKDIR
fa=./batsGenome/eonSpe/GCF_20170106.fa
mkdir $fa.mask
/LinuxData/software/src/RepeatMasker/RepeatMasker -pa 45 -s -norna -species mammal -dir $fa.mask $fa
#--------------------------------------------------
# outdir=$fa.chrs
# mkdir $outdir
# cd $outdir
# ln -s ../$fa
# cd ..
# faSplit byName ./$outdir/$fa ./$outdir
# rm $outdir/$fa
# mkdir $fa.trf
# for i in $outdir/*.fa; do trfBig $i $fa.trf/`basename $i`; done
#--------------------------------------------------
#--------------------------------------------------
# for i in in /* cs2/*; do faToNib $i `echo $i | sed -e s/.fa/.nib/`; done
#--------------------------------------------------
