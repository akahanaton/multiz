for dir in ./batsGenome/[[:lower:]]*[[:upper:]]*
do
    code=`basename $dir`
    echo $code
    fa=`ls $dir/*genomic.fna`
    mkdir $dir/$code.chrUn
    python3 ./build_chrUn.py 100 $fa $dir/$code.chrUn $dir/$code.chrUn.agp
done
#--------------------------------------------------
# mkdir ./batsGenome/eidHel/eidHel.chrUn
# ./build_chrUn.py 100 ./batsGenome/eidHel/GCA_000465285.1_ASM46528v1_genomic.fna ./batsGenome/eidHel/eidHel.chrUn ./batsGenome/eidHel/eidHel.chrUn.agp
# mkdir ./batsGenome/eonSpe/eonSpe.chrUn
# ./build_chrUn.py 100 ./batsGenome/eonSpe/p_ctg.fa ./batsGenome/eonSpe/eonSpe.chrUn ./batsGenome/eonSpe/eonSpe.chrUn.agp
# mkdir ./batsGenome/eptFus/eptFus.chrUn
# ./build_chrUn.py 100 ./batsGenome/eptFus/GCF_000308155.1_EptFus1.0_genomic.fna ./batsGenome/eptFus/eptFus.chrUn ./batsGenome/eptFus/eptFus.chrUn.agp
# mkdir ./batsGenome/megLyr/megLyr.chrUn
# ./build_chrUn.py 100 ./batsGenome/megLyr/GCA_000465345.1_ASM46534v1_genomic.fna ./batsGenome/megLyr/megLyr.chrUn ./batsGenome/megLyr/megLyr.chrUn.agp
# mkdir ./batsGenome/minNat/minNat.chrUn
# ./build_chrUn.py 100 ./batsGenome/minNat/GCF_001595765.1_Mnat.v1_genomic.fna ./batsGenome/minNat/minNat.chrUn ./batsGenome/minNat/minNat.chrUn.agp
# mkdir ./batsGenome/myoBra/myoBra.chrUn
# ./build_chrUn.py 100 ./batsGenome/myoBra/GCF_000412655.1_ASM41265v1_genomic.fna ./batsGenome/myoBra/myoBra.chrUn ./batsGenome/myoBra/myoBra.chrUn.agp
# mkdir ./batsGenome/myoLuc/myoLuc.chrUn
# ./build_chrUn.py 100 ./batsGenome/myoLuc/GCF_000147115.1_Myoluc2.0_genomic.fna ./batsGenome/myoLuc/myoLuc.chrUn ./batsGenome/myoLuc/myoLuc.chrUn.agp
# mkdir ./batsGenome/pteAle/pteAle.chrUn
# ./build_chrUn.py 100 ./batsGenome/pteAle/GCF_000325575.1_ASM32557v1_genomic.fna ./batsGenome/pteAle/pteAle.chrUn ./batsGenome/pteAle/pteAle.chrUn.agp
# mkdir ./batsGenome/ptePar/ptePar.chrUn
# ./build_chrUn.py 100 ./batsGenome/eptFus/GCF_000308155.1_EptFus1.0_genomic.fna ./batsGenome/eptFus/eptFus.chrUn ./batsGenome/eptFus/eptFus.chrUn.agp
# mkdir ./batsGenome/pteVam/pteVam.chrUn
# ./build_chrUn.py 100 ./batsGenome/eptFus/GCF_000308155.1_EptFus1.0_genomic.fna ./batsGenome/eptFus/eptFus.chrUn ./batsGenome/eptFus/eptFus.chrUn.agp
# mkdir ./batsGenome/rhiFer/rhiFer.chrUn
# ./build_chrUn.py 100 ./batsGenome/eptFus/GCF_000308155.1_EptFus1.0_genomic.fna ./batsGenome/eptFus/eptFus.chrUn ./batsGenome/eptFus/eptFus.chrUn.agp
# mkdir ./batsGenome/rouAeg/rouAeg.chrUn
# ./build_chrUn.py 100 ./batsGenome/eptFus/GCF_000308155.1_EptFus1.0_genomic.fna ./batsGenome/eptFus/eptFus.chrUn ./batsGenome/eptFus/eptFus.chrUn.agp
#--------------------------------------------------
