### RULE 1 FOR CALLING ALLELES

## list of uniq sequences

cat $workdir/*.fasta > $workdir/Prep/cat.tmp
paste - - < $workdir/Prep/cat.tmp > $workdir/Prep/cat.txt

# to create a file with the total number of alleles
cut -f 2 $workdir/Prep/cat.txt | sort | uniq -c | sort -n > $workdir/Prep/hapfile_10Perc.txt 


#re-format eliminating tab at the begining of each line and col separated by tab (and not space)
awk '{$1=$1}1' OFS="\t" $workdir/Prep/hapfile_10Perc.txt > $workdir/Prep/hapfile_10Perc_ed.txt

### checked in Bioedit. Eliminate variants with only 1 or 2 nt differences: allele23 y 15,
## rename
sed -i '15d' $workdir/Prep/hapfile_10Perc_ed.txt
#I want to erase number 23 but since we already erased one line, now is number 22
sed -i '22d' $workdir/Prep/hapfile_10Perc_ed.txt

## name this alleles 
awk '{print "allele"NR"\t"$2}' $workdir/Prep/hapfile_10Perc_ed.txt > $workdir/Prep/hapfile_10Perc_ed_names.txt

## convert to fasta
awk '{print ">"$1"\n"$2}' $workdir/Prep/hapfile_10Perc_ed_names.txt > $workdir/Prep/hapfile_10Perc_ed_names.fasta
