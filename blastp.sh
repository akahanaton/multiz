for fa in ./DEA_Viral_Peptidome_Annotation.fa.cut/2.fa
do
    ./ncbi-blast-2.4.0+/bin/blastp -task blastp-fast -word_size 2 -query $fa -num_threads 8 -db ./ncbi-blast-2.4.0+/db/viral.pro -evalue 0.001 -out $fa.blastp -outfmt "6 qseqid qlen qstart qend qcovs sseqid slen sstart send sstrand length evalue pident mismatch gaps sscinames staxid"
done
