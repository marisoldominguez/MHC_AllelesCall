# MHC_AllelesCall
workflow of commands used to define true MHC alleles starting from fasta files, using cutadapt, other built-in scripts and manually editing with BioEdit.


NameAlleles10Perc.sh: Naming alleles after filtering 10% lowest freq reads but not demanding it to be in more than 1 individual

NameAlleles10Percmore1Indiv.sh: discard sequences that appear only once

NameAlleles_1ntDif.sh NameAlleles_2ntDif.sh and : based on verified alleles (filter 10% lowest freq reads + appear in more than 1 individual) discard those that only have 1 or 2 nt of difference with the verified alleles (because they could be sequencing erros).

SumCount.sh: sum count for sequences that belong to same haplotype. 
##very slow. To make it faster I separated infiles in different folders and run different slurm files
