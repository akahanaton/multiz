#--------------------------------------------------
# maf_cov_per_align.py hg38.maf ./all3.list > hg38.maf.cov
#--------------------------------------------------
awk '$5>($9+20) && $7>0' hg38.maf.cov | wc -l
awk '$9>($5+20) && $7>0' hg38.maf.cov | wc -l

awk '{if($5>($9+20) && $7>0) {a = a+$3-$2}} END {print a}' hg38.maf.cov
awk '{if($9>($5+20) && $7>0) {a = a+$3-$2}} END {print a}' hg38.maf.cov
