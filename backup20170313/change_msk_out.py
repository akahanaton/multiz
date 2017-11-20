#!/home/gmswenm/python/bin/python3
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import generic_rna
import os


def uniq_by_field(infile, field_num):
    infile_h = open(infile,'r')
    alllines= infile_h.readlines()
    infile_h.close()

    pre_key = ''
    for eachline in alllines:
            arr = eachline.rstrip().split()
            if arr[field_num -1] != pre_key:
                    print eachline.rstrip()
            pre_key = arr[field_num-1]

    with open(infile) as f:
        for line in f:
            print(line)
    f.close()

def getColumn(col_num, data):
    column = []
    for i in range (0, len(data)):
        row = data[i]
        column.append(row[col_num])
    return column

    output_handle = open(newSeqFile, "w")
    for row in range(0, totalSeq):
        output_handle.write(">"+seqNames[row]+"\n")
        output_handle.write(''.join(map(str, seqArr[row])) + "\n")
    output_handle.close()

if __name__ == '__main__':
    import sys
    def usage():
        print('uniq eachline by field, field begin with 1')
        print('usage:  python3',sys.argv[0],'tree.file  seq.file tree.file.new seq.file.new drop.species')
        sys.exit(1)

    argc = len(sys.argv)
    if argc < 5:
        usage()

    treeFile = sys.argv[1]
    seqFile = sys.argv[2]
    newTreeFile = sys.argv[3]
    newSeqFile = sys.argv[4]
    dropSpecies = ''
    if (len(sys.argv) > 5):
        dropSpecies = sys.argv[5]

    seqNames=[]
    seqArrs=[]
    seqIndex = 0
    refSeqIndex = 0
    seqHandle = open(seqFile, "rU")
    for record in SeqIO.parse(seqHandle, "fasta"):
        if record.id == dropSpecies:
            continue
        seqNames.append(record.id)
        seqArrs.append(list(record.seq))
        seqIndex = seqIndex + 1
        if record.id == 'homSap':
            refSeqIndex = seqIndex - 1
    seqHandle.close()


    tree = Tree(treeFile, format=1)
    tree.prune(seqNames, preserve_branch_length=False)
    tree.write(format=1, outfile=newTreeFile)
    

