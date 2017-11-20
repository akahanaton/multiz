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
        print('build virtual-chromosome, each per un.number contigs')
        print('usage: python3', sys.argv[0], 'un.number raw.seq.fa output.dir  agp.file')
        sys.exit(1)

    argc = len(sys.argv)
    if argc < 2:
        usage()

    seqNum     = int(sys.argv[1])
    rawSeqFile = sys.argv[2]
    outDir = sys.argv[3]
    agpFile    = sys.argv[4]

    seqStr = dict()

 #--------------------------------------------------
 # If the line represents an actual sequence record then it has the form
 # <chromosome/ctg> <start-in-ctg> <end-in-ctg> <number> <type> <accession>.<version> <start> <end> <orientation>
 # and if it represents a gap it has the form
 # <chromosome/ctg> <start-in-ctg> <end-in-ctg> <number> N <number-of-Ns> <kind> <bridged?>
 #--------------------------------------------------

    agp_handle = open(agpFile,'w')

    seqHandle = open(rawSeqFile, "rU")
    for record in SeqIO.parse(seqHandle, "fasta"):
        if(record.seq.find('N') == -1 or len(record.seq) < 2000000):
            seqStr[record.id] = record.seq;
        else:
            newSeqFile=outDir+"/"+record.id+".fa"
            outseq_handle = open(newSeqFile, "w")
            SeqIO.write(record, outseq_handle, "fasta")
            agp_handle.write(("%s\\%s\t%d\t%d\t%d\t%s\t%s\t%d\t%d\t%s\n") % (record.id, record.id, 1, len(record.seq), 1, "D", record.id, 1, len(record.seq), "+"))
            outseq_handle.close()

    IDs = list(seqStr.keys())
    ID_number = len(seqStr)
    ID_per_seq = int(ID_number / seqNum) + 1
    j = 0
    curID = "chrUn" + str(j)
    curSeq= seqStr[IDs[0]]
    curBeg = 1
    curEnd = len(curSeq) - 1
    agp_handle.write(("%s\\%s\t%d\t%d\t%d\t%s\t%s\t%d\t%d\t%s\n") % (curID, IDs[0], curBeg, curEnd, 1, "D", IDs[0], 1, len(curSeq), "+"))
    for i in range(1, ID_number):
        curSeq =curSeq + seqStr[IDs[i]]
        curBeg = curEnd + 1
        curEnd = curBeg + len(curSeq) - 1
        agp_handle.write(("%s\\%s\t%d\t%d\t%d\t%s\t%s\t%d\t%d\t%s\n") % (curID, IDs[i], curBeg, curEnd, 1, "D", IDs[i], 1, len(curSeq), "+"))
        if(i % ID_per_seq == 0):
            newSeqFile=outDir+"/"+curID+".fa"
            outseq_handle = open(newSeqFile, "w")
            outseq_handle.write(">"+curID+"\n")
            outseq_handle.write(str(curSeq)+"\n")
            j = j + 1
            curID = "chrUn" + str(j)
            curSeq = seqStr[IDs[i]]
            curBeg = 1
            curEnd = len(curSeq) - 1
            outseq_handle.close()
            agp_handle.write(("%s\\%s\t%d\t%d\t%d\t%s\t%s\t%d\t%d\t%s\n") % (curID, IDs[i], curBeg, curEnd, 1, "D", IDs[i], 1, len(curSeq), "+"))
        if(i == ID_number -1):
            newSeqFile=outDir+"/"+curID+".fa"
            outseq_handle = open(newSeqFile, "w")
            outseq_handle.write(">"+curID+"\n")
            outseq_handle.write(str(curSeq)+"\n")
            outseq_handle.close()
    agp_handle.close()
