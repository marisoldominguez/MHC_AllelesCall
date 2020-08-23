## RULE 2 FOR CALLING ALLELES
# discard from the sequences that passed filter 1 (10% freq) the ones tha appear in only 1 individual

awk '$1>1' $workdir/Prep/hapfile_10Perc_ed.txt > $workdir/Prep/hapfile_10Perc_ed_more1Indiv.txt 

## name this alleles 
awk '{print "allele"NR"\t"$2}' $workdir/Prep/hapfile_10Perc_ed_more1Indiv.txt > $workdir/Prep/hapfile_10Perc_ed_more1Indiv_names.txt

## convert to fasta
awk '{print ">"$1"\n"$2}' $workdir/Prep/hapfile_10Perc_ed_more1Indiv_names.txt > $workdir/Prep/hapfile_10Perc_ed_more1Indiv_names.fasta
