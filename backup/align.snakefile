import glob, os

queryNib="000127F"

targetNibs = [os.path.basename(f) for f in glob.glob('batsGenome/pteAle/pteAle2.nib2/NW_0064870*.nib')]

print(len(targetNibs))

rule all:
    input: "batsGenome/eonSpe/eonSpe2.pteAle2.chain/merge/" + queryNib + ".chain"

rule lastz:
    input:  queryNib="batsGenome/eonSpe/eonSpe2.nib2/" + queryNib + ".nib",
            targetNib="batsGenome/pteAle/pteAle2.nib2/{A}"
    output: "batsGenome/eonSpe/eonSpe2.pteAle2.lav/" + queryNib + "_{A}.lav"
    shell: "lastz {input.targetNib} {input.queryNib} --inner=2000 --ydrop=3400 --gappedthresh=3000 --hspthresh=3000 --notransition --step=4 --scores=HaploMerger_20120810/project_template/scoreMatrix.q > {output}"

rule psl:
    input: lavs="batsGenome/eonSpe/eonSpe2.pteAle2.lav/" + queryNib + "_{A}.lav"
    output: psls="batsGenome/eonSpe/eonSpe2.pteAle2.psl/" + queryNib + "_{A}.psl"
    shell: "lavToPsl {input.lavs} {output.psls}"

rule chain:
    input: psls="batsGenome/eonSpe/eonSpe2.pteAle2.psl/" + queryNib + "_{A}.psl"
    output: chains="batsGenome/eonSpe/eonSpe2.pteAle2.chain/" + queryNib + "_{A}.chain"
    shell: "axtChain.raw -linearGap=loose -psl {input.psls} batsGenome/pteAle/pteAle2.nib2 batsGenome/eonSpe/eonSpe2.nib2 {output.chains}"

rule chainMerge:
    input: chains=expand("batsGenome/eonSpe/eonSpe2.pteAle2.chain/" + queryNib + "_{A}.chain", A=targetNibs)
    output: "batsGenome/eonSpe/eonSpe2.pteAle2.chain/merge/" + queryNib + ".chain"
    shell: "chainMergeSort -tempDir=batsGenome/eonSpe/eonSpe2.pteAle2.chain/merge {input.chains} > {output}"

