#!/usr/bin/env bash

cd $PBS_O_WORKDIR

set -euo pipefail

#--------------------------------------------------
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/eidHel/eidHel2.hg38.maf > ./eidHel2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/eonSpe/eonSpe2.hg38.maf > ./eonSpe2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/eptFus/eptFus2.hg38.maf > ./eptFus2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/megLyr/megLyr2.hg38.maf > ./megLyr2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/minNat/minNat2.hg38.maf > ./minNat2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/myoBra/myoBra2.hg38.maf > ./myoBra2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/myoLuc/myoLuc2.hg38.maf > ./myoLuc2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/pteAle/pteAle2.hg38.maf > ./pteAle2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/ptePar/ptePar2.hg38.maf > ./ptePar2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/pteVam/pteVam2.hg38.maf > ./pteVam2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/rhiFer/rhiFer2.hg38.maf > ./rhiFer2.hg38.cov
# ./src/mafTools/bin/mafCoverage --identity -m batsGenome/rouAeg/rouAeg2.hg38.maf > ./rouAeg2.hg38.cov
#--------------------------------------------------

for maf in ./hg38_maf/*.maf
do
    ./src/mafTools/bin/mafCoverage --identity -m $maf > $maf.cov
done
