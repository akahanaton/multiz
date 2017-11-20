#--------------------------------------------------
# lavCmdDir=./cmdLav.eidHel2.pteAle2
#--------------------------------------------------
lavCmdDir=./cmdLav.eonSpe2.pteAle2
for index in {0..3000}; do
    file=`ls $lavCmdDir/*.$index.sh`
    id=`basename $file`
    echo $file
    qsub -q "all.q@compute-8-9,all.q@compute-8-3,all.q@compute-8-2*" -o $lavCmdDir -N $id bash $file
done
