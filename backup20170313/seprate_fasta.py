#!/usr/bin/python3
from random import shuffle
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
                    print(eachline.rstrip())
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
        print('usage: python3', sys.argv[0], 'chr.number raw.seq.fa output.dir')
        sys.exit(1)

    argc = len(sys.argv)
    if argc < 2:
        usage()

    seqNum     = int(sys.argv[1])
    rawSeqFile = sys.argv[2]
    outDir = sys.argv[3]

    seqStr = dict()

 #--------------------------------------------------
 # If the line represents an actual sequence record then it has the form
 # <chromosome/ctg> <start-in-ctg> <end-in-ctg> <number> <type> <accession>.<version> <start> <end> <orientation>
 # and if it represents a gap it has the form
 # <chromosome/ctg> <start-in-ctg> <end-in-ctg> <number> N <number-of-Ns> <kind> <bridged?>
 #--------------------------------------------------


    seqHandle = open(rawSeqFile, "rU")
    for record in SeqIO.parse(seqHandle, "fasta"):
        if(record.seq.find('N') == -1 or len(record.seq) < 2000000):
            seqStr[record.id] = record.seq;
        else:
            newSeqFile=outDir+"/"+record.id+".fa"
            outseq_handle = open(newSeqFile, "w")
            SeqIO.write(record, outseq_handle, "fasta")
            outseq_handle.close()

    IDs = list(seqStr.keys())
    ID_number = len(seqStr)
    ID_per_seq = int(ID_number / seqNum) + 1
    j = 0
    curID = "seq" + str(j)
    newSeqFile=outDir+"/"+curID+".fa"
    outseq_handle = open(newSeqFile, "w")
    for i in range(0, ID_number):
        if(i % ID_per_seq != 0):
            outseq_handle.write(">"+IDs[i]+"\n")
            outseq_handle.write(str(seqStr[IDs[i]])+"\n")
        else:
            outseq_handle.write(">"+IDs[i]+"\n")
            outseq_handle.write(str(seqStr[IDs[i]])+"\n")
            outseq_handle.close()
            j = j + 1
            curID = "seq" + str(j)
            newSeqFile=outDir+"/"+curID+".fa"
            outseq_handle = open(newSeqFile, "w")
    outseq_handle.close()
