#!/bin/bash
find /wlflab/.snakemake/code_tracking -type f -atime 0.05 -delete
find /wlflab/.snakemake/input_tracking -type f -atime 0.05 -delete
find /wlflab/.snakemake/params_tracking -type f -atime 0.05 -delete
find /wlflab/.snakemake/rule_tracking -type f -atime 0.05 -delete
find /wlflab/.snakemake/shellcmd_tracking -type f -atime 0.05 -delete
