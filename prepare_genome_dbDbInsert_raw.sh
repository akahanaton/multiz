for speDir in `ls -d batsGenome/[[:lower:]]*[[:upper:]]*`
do
    id=`basename $speDir`2
    if [ -e $speDir/$id.sql ]; then
        hgsql hgcentral < $speDir/$id.sql
        mkdir /synology/gbdb/$id/track_files
        touch /synology/gbdb/$id/track_files/trackDb.ra
    fi
done


hgsql hgcentral -e 'INSERT INTO defaultDb (genome, name) VALUES ("P. alecto", "pteAle2");'
hgsql hgcentral -e 'INSERT INTO genomeClade (genome, clade, priority) VALUES ("P. alecto", "vertebrate", 123);'
hgTrackDb /synology/gbdb/eonSpe2 eonSpe2 trackDb /home/gmswenm/wlflab/reference_genomes2/kentUtils/src/hg/lib/trackDb.sql /synology/gbdb/eonSpe2/track_files
hgFindSpec /synology/gbdb/pteAle2 pteAle2 hgFindSpec /home/gmswenm/wlflab/reference_genomes2/kentUtils/src/hg/lib/hgFindSpec.sql /synology/gbdb/pteAle2/track_files

hgsql hgcentral -e 'INSERT INTO defaultDb (genome, name) VALUES ("E. Spelaea", "eonSpe2");'
hgsql hgcentral -e 'INSERT INTO genomeClade (genome, clade, priority) VALUES ("E. Spelaea", "vertebrate", 123);'
hgTrackDb /synology/gbdb/eonSpe2 eonSpe2 trackDb /home/gmswenm/wlflab/reference_genomes2/kentUtils/src/hg/lib/trackDb.sql /synology/gbdb/eonSpe2/track_files
hgFindSpec /synology/gbdb/eonSpe2 eonSpe2 hgFindSpec /home/gmswenm/wlflab/reference_genomes2/kentUtils/src/hg/lib/hgFindSpec.sql /synology/gbdb/eonSpe2/track_files

