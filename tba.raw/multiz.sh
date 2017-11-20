#--------------------------------------------------
# qsub multiz M=1 eonSpe2.hg38.sing.maf pteAle2.hg38.sing.maf 1 eonSpe2.unuse pteAle2.unuse -o multiz.eonSpe2.pteAle2.maf
# qsub multiz M=1 eidHel2.hg38.sing.maf eptFus2.hg38.sing.maf 1 eidHel2.unuse eptFus2.unuse -o multiz.eidHel2.eptHel2.maf
# qsub multiz M=1 megLyr2.hg38.sing.maf minNat2.hg38.sing.maf 1 myoLyr2.unuse minNat2.unuse -o multiz.myoLyr2.minNat2.maf
# qsub multiz M=1 myoBra2.hg38.sing.maf myoLuc2.hg38.sing.maf 1 myoBra2.unuse myoLyr2.unuse -o multiz.myyBra2.myoLyr2.maf
# qsub multiz M=1 ptePar2.hg38.sing.maf pteVam2.hg38.sing.maf 1 ptePar2.unuse pteVam2.unuse -o multiz.ptePar2.pteVam2.maf
# qsub multiz M=1 rhiFer2.hg38.sing.maf rouAeg2.hg38.sing.maf 1 rhiFer2.unuse rouAeg2.unuse -o multiz.rhiFer2.rouAeg2.maf
#--------------------------------------------------
qsub -o part1.maf multiz multiz.eonSpe2.pteAle2.maf multiz.eidHel2.eptFus2.maf 1 multiz.eonSpe2.pteAle2.maf.unuse multiz.eidHel2.eptFus2.maf.unuse
qsub -o part2.maf multiz multiz.myoBra2.myoLyr2.maf multiz.myoLyr2.minNat2.maf 1 multiz.myoBra2.myoLyr2.maf.unuse multiz.myoLyr2.minNat2.maf.unuse
#--------------------------------------------------
# qsub multiz multiz.ptePar2.pteVam2.maf multiz.rhiFer2.rouAeg2.maf 1 multiz.ptePar2.pteVam2.maf.unuse multiz.rhiFer2.rouAeg2.maf.unuse 1> part3.maf
#--------------------------------------------------
