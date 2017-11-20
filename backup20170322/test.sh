for j in `find batsGenome/eonSpe/eonSpe2.nib2/ -name *.nib`; do
    targetChr=`basename $j .nib`;
    lav=batsGenome/eidHel/eidHel2.eonSpe2.lav/1/eidHel2.eonSpe2.KE747934.1.$targetChr.lav
    psl=`echo $lav | sed 's/lav/psl/g'`
    chain=`echo $lav | sed 's/lav/chain/g'`
    lastz $j batsGenome/eidHel/eidHel2.nib2/KE747934.1.nib --inner=2000 --ydrop=3400 --gappedthresh=3000 --hspthresh=3000 --notransition --step=4 --scores=HaploMerger_20120810/project_template/scoreMatrix.q > $lav;
    lavToPsl $lav $psl
    axtChain -linearGap=loose -psl $psl batsGenome/eonSpe/eonSpe2.nib2 batsGenome/eidHel/eidHel2.nib2 $chain
done
chainMergeSort batsGenome/eidHel/eidHel2.eonSpe2.chain/1/eidHel2.eonSpe2.KE747934.1.*.chain > batsGenome/eidHel/eidHel2.eonSpe2.chain/merge/1/eidHel2.eonSpe2.KE747934.1.chain

