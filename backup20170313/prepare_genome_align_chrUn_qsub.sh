#--------------------------------------------------
# lavCmdDir=./cmdLav.eidHel2.pteAle2
#--------------------------------------------------
lavCmdDir=./cmdLav.pteAle1.hg38
for file in `ls $lavCmdDir/*.sh`
do
    dir=`dirname $file`
    id=`basename $file .sh`
    if [ ! -e $dir/$id.o* ]; then
        echo $file
        qsub -q "all.q@compute-9-*,all.q@compute-8-1*" -o $dir -N $id bash $file
        sleep 0.5
    fi
done
