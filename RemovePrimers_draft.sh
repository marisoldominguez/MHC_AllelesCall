### script to remove primers using cutadapt
#https://cutadapt.readthedocs.io/en/stable/recipes.html
# -a means that it has to be looked for in 3´ end 

#test with only one sample
cutadapt -a ^CCATGGGTCTCTGTGGGTA...GGTGDGARCAGAATTMYTGWG -o /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/MHCI_Q20/MaD_CO04_Refined_PrimerRem.fa /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/BWA_Fasta_Q20/MHCI/MaD_CO04_Refined.fa


#####Q20
### for loop

#create a file with the names of all files (1perIndiv) to loop in
cd /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/BWA_Fasta_Q20/MHCI/
ls *.fa > list_files.txt
sed 's/_/\t/g' list_files.txt > /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/list_files_tab.txt

workdir='/hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')
#end=2

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    cutadapt -a ^CCATGGGTCTCTGTGGGTA...GGTGDGARCAGAATTMYTGWG -o /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/MHCI_Q20/MaD_${id}_Refined_PrimerRem.fa /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/BWA_Fasta_Q20/MHCI/MaD_${id}_Refined.fa
done

#####Q30

workdir='/hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')
#end=2

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    cutadapt -a ^CCATGGGTCTCTGTGGGTA...GGTGDGARCAGAATTMYTGWG -o /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/MHCI_Q30/MaD_${id}_Refined_PrimerRem.fa /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/BWA_Fasta_Q30/MHCI/MaD_${id}_Refined.fa
done

#### it worked well but in some sequences there still the reverse primer 
#### I looked in the original fasta file that Binia sent and those sequence were lacking the forward primer
#### this is why it did not work, the command specified to erase F and R when there were something in the middle (...), so both had to be present in the sequence 

### command to delete those leftovers of reverse primer
## 3’ adapter type (-a)

/hpc-cloud/uprojects/packages/.virtual/python3.8.1/cutadapt/2.10/bin/cutadapt -a GGTGDGARCAGAATTMYTGWG -o /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/MHCI_Q20/withoutReverse/MaD_CO04_Refined_PrimerRemRev.fa /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/MHCI_Q20/MaD_CO04_Refined_PrimerRem.fa

## do it in a loop and save it in scratch directory !!!!!!!!!!!!
##Q20

workdir='/hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')
#end=2

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    /hpc-cloud/uprojects/packages/.virtual/python3.8.1/cutadapt/2.10/bin/cutadapt -a GGTGDGARCAGAATTMYTGWG -o /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/MaD_CO04_Refined_PrimerRemRev.fa $workdir/MHCI_Q20/MaD_CO04_Refined_PrimerRem.fa
done

##Q30



###pruebas !!!!!!!!!!!!!!!!!

/hpc-cloud/uprojects/packages/.virtual/python3.8.1/cutadapt/2.10/bin/cutadapt -a GGTGDGARCAGAATTMYTGWG -o /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/MaD_CO04_Refined_PrimerRemRev.fa /hpc-cloud/users/mathnat/ibb/dominguez/MHC_data_new/PrimersRemoved/MHCI_Q20/MaD_CO04_Refined_PrimerRem.fa


#################### oneline ##############################
# test with one file
cd /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/
paste - - < MaD_CO04_Refined_PrimerRemRev.fa> /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/CO04_oneline.fa

##now a loop
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    paste - - < MaD_${id}_Refined_PrimerRemRev.fa> $workdir/oneline/${id}_oneline.fa
done

##################################### count unique sequences #########

# test with one file
cut -f 2 CO04_oneline.fa | sort | uniq -c | sort -n > CO04_uniq.txt

#loop
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    cut -f 2 $workdir/oneline/${id}_oneline.fa | sort | uniq -c | sort -n > $workdir/oneline/uniq/${id}_uniq.txt
done

##  for Q30
#oneline

cd /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q30/withoutReverse/

workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q30/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    paste - - < MaD_${id}_Refined_PrimerRemRev.fa> $workdir/oneline/${id}_oneline.fa
done

##################################### count unique sequences #########
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q30/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    cut -f 2 $workdir/oneline/${id}_oneline.fa | sort | uniq -c | sort -n > $workdir/oneline/uniq/${id}_uniq.txt
done


###############################################
######### CUT OFF BINIA RULES #################
#1. remove 10% lowest frew reads
# for file /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q30/withoutReverse/oneline/uniq/CO04_uniq.txt
# last row show maximun count= 1861
# so remove all sequences ocurring less than 186 times

#solve formating problem (files start with a tab)
cat $workdir/oneline/uniq/CO04_uniq.txt | sed -e 's/^[ \t]*//'  > $workdir/oneline/uniq/CO04_uniq_ed.txt

workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q30/withoutReverse'
awk '$1 >= 186' $workdir/oneline/uniq/CO04_uniq_ed.txt > $workdir/oneline/uniq/LowFreq/CO04_uniq_lowfreq.txt

## now a loop
# need to find in an automatic way of calculating the 10% of maximun value of col 1
# divide by 10 value of last row first col, stored it in a variable

Perc=$(cat $workdir/oneline/uniq/CO06_uniq.txt | tail -n1 | awk '{print $1/10}')
echo $Perc


##  for Q20
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')


for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    Perc=$(cat $workdir/oneline/uniq/${id}_uniq.txt | tail -n1 | awk '{print $1/10}')
    cat $workdir/oneline/uniq/${id}_uniq.txt | sed -e 's/^[ \t]*//' | awk -v Perc="$Perc" '$1 >= Perc' > $workdir/oneline/uniq/LowFreq/${id}_uniq_lowfreq.txt
done

##  for Q30
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q30/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')


for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    Perc=$(cat $workdir/oneline/uniq/${id}_uniq.txt | tail -n1 | awk '{print $1/10}')
    cat $workdir/oneline/uniq/${id}_uniq.txt | sed -e 's/^[ \t]*//' | awk -v Perc="$Perc" '$1 >= Perc' > $workdir/oneline/uniq/LowFreq/${id}_uniq_lowfreq.txt
done



### see the alignment for each ID in BioEdit or Genious

### but first convert in Galaxy from tabulat to fasta format *** (see end of this file fot alternative way) ***
# download files and saved in D:\postdoc\Paper MHC\scripts/Q20 o /Q30 with names ${id}_uniq_lowfreq.fasta. Open en Galaxy, convert, save as .fasta

# it is space separated and I need it tab separated

#Q20
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    awk '{$1=$1}1' OFS="\t" $workdir/oneline/uniq/LowFreq/${id}_uniq_lowfreq.txt > /$workdir/oneline/uniq/LowFreq/LowFreqFasta/${id}_uniq_lowfreq_ed.txt
done

#Q30
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q30/withoutReverse'
end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')

for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    awk '{$1=$1}1' OFS="\t" $workdir/oneline/uniq/LowFreq/${id}_uniq_lowfreq.txt > /$workdir/oneline/uniq/LowFreq/LowFreqFasta/${id}_uniq_lowfreq_ed.txt
done



# In Bioedit manually erase introns and sequence that are too short !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

############################
### BINIA'S RULE ONLY PART A
# use files filtered by 10% freq but not demanding it to be in more than 1 individual (already edited in BioEdit)

workdir=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta


#concatenate to have list of uniq sequences (haplotype file)
cat $workdir/*.fasta > $workdir/Prep/cat.tmp
#276 lineas wc -l
paste - - < $workdir/Prep/cat.tmp > $workdir/Prep/cat.txt

# to create a file with the total number of alleles
cut -f 2 $workdir/Prep/cat.txt | sort | uniq -c | sort -n > $workdir/Prep/hapfile_10Perc.txt 
#47 lineas wc -l. Para la parte B eliminar todos los que tienen count 1 (aparecen en un 1) 

#queda tab al principio de cada linea y columnas separados por espacio
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


##loop to change the name of allele in each individual fasta
./NameAlleles10Perc.sh hapfile_10Perc_ed_names.txt /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta

mv /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/Prep/AllelesNamed10Perc /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/

##************convert all files from tab to fasta (eventhough they are called .fasta they are not in the good format) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

###############################
### BINIA'S RULE ONLY PART B
# discard sequences that appear only once
awk '$1>1' $workdir/Prep/hapfile_10Perc_ed.txt > $workdir/Prep/hapfile_10Perc_ed_more1Indiv.txt 

## name this alleles 
awk '{print "allele"NR"\t"$2}' $workdir/Prep/hapfile_10Perc_ed_more1Indiv.txt > $workdir/Prep/hapfile_10Perc_ed_more1Indiv_names.txt

## convert to fasta
awk '{print ">"$1"\n"$2}' $workdir/Prep/hapfile_10Perc_ed_more1Indiv_names.txt > $workdir/Prep/hapfile_10Perc_ed_more1Indiv_names.fasta

##loop to change the name of allele in each individual fasta
workdir=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/Prep

./NameAlleles10Percmore1Indiv.sh hapfile_10Perc_ed_more1Indiv_names.txt /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta

mv /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/Prep/AllelesNamed10Perc1Indiv /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/

##******convert all files from tab to fasta (eventhough they are called .fasta they are not in the good format) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


##############################################################################################################################

### INDIVIDUAL FASTA FILES WITH SEQUENCES NAMED (filtered by frequency) STORED IN /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/AllelesNamed10Perc/
#(allele1-allele47)
#max number of alleles per indiv: 22 (CO06), 8 (RO21)

wc -l /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/AllelesNamed10Perc/*.fasta | sort -g

#############################################################################################################################
###INDIVIDUAL FASTA FILES WITH SEQUENCES NAMED (filtered by frequency AND in more than 1 individual) STORED IN /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/Prep/AllelesNamed10Perc1Indiv/
#(allele1-allele9)
#max number of alleles per indiv: 4 (LO10)
wc -l /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/Prep/AllelesNamed10Perc1Indiv/*.fasta | sort -g



# convert the txt files in fasta



############la cague! tengo que generar de vuelta los files de 
#/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/newindiv/


###############################################
######### CUT OFF RALPH RULES #################

## demand sequencing reads to have 10 or 20 reads per individual
## how many individuals will have cero alleles because their frequency is less than 10? CO06, CO40,CO47, RO14, RO21

##for RO02 I did it manually. In Bioedit erased introns (saved as D:\postdoc\Paper MHC\Q20\Filter_more10reads\RO02_uniq_10reads.fas) and then in DNAsp define haplotypes, then back in Bioedit sum count for sequences that belong to same haplotype and saved it as (RO02_uniq_10reads_hap.fas)

## find automatic way of erasing introns because it is a lot of work, there are many sequences per *_uniq.fas
# erase too short sequences. Only print sequences longer than 275 (known lenght of exon)

awk 'BEGIN {RS = ">" ; ORS = ""} length($2) >= 274 {print ">"$0}' RO02_uniq.fasta > RO02_uniq_ShortErased.fasta


#erase fixed sequence of introns (eventhough I know a lot will stay because they have a CC repeat that varies in leght 
# # use -g option to only look at 5´end. https://cutadapt.readthedocs.io/en/stable/guide.html

cutadapt -g ^CAACCCCCCCA -o /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/RO02_uniq_IntronRem.fa /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/RO02_uniq.fasta

# both scripts saved in RemoveIntron.sh and run as submit_RemoveIntron.slurm

#change the pattern to the most frequent sequences of introns I see (D/postdoc/Paper MHC/script/introns.docx
## can I use cutadapt to cut multiple different intron sequences at the 5´end ???????????????????????????????????????????????????????????????????????????????

https://cutadapt.readthedocs.io/en/stable/guide.html#multiple-adapters
#since if there are several matches i will choose the first in the command, I ordered them from longer to shorter
#modify RemoveIntron.sh
cutadapt -g ^CTCTTCCGATCTCCATGGGTCTCTGTGGGTACAACCCCCCCA -g ^CTCTTCCGATCTCTCTGTGGGTACAACACCCCCA -g ^ATGGGTCTCTGTGGGTACAACCCCCCCA -g ^GGGTCTCTGTGGGTACAACCCCCCCA -g ^GGTCTCTGTGGGTACAACCCCACCA -g ^GTCTCTGTGGGCACAACCCCCCCA -g ^CTCTGTGGGTACAACCCCCCCAG -g ^CGACCCCCCCA -g ^AAACACCCCCA -g ^AAACCCCCCCA -g ^CAAACCCCCCA -g ^CAACCCCCCCA -g ^CAACCCCACCA -g ^CAACCCCCCCT -g ^CAACCCCCTCA -g ^CAACCCCTCCA -g ^CAACTCCCCCA -g ^CAATACCCCCA -g ^CAATCCCCCCA -g ^CCACCCCCCCA -g ^CAACCCCCCA -g ^CAACCCCCAC -g ^CAATCCCCCA -g ^CACCCCCCCA -g ^CAGCCCCCCC -g ^ACCCCCCCA -g ^CCCCCCCA -g ^CCCCCCA -g ^CCCA -g ^CCA -o $workdir/oneline/uniq/ed/IntronRemoved/${id}_uniq_IntronRem.fa $workdir/oneline/uniq/ed/${id}_uniq_ShortErased.fasta


###Open files $workdir/oneline/uniq/ed/IntronRemoved/${id}_uniq_IntronRem.fa $workdir/oneline/uniq/ed/${id}_uniq_ShortErased.fasta in Bioedit to double check there is no intron remaining
# Open in DNAsp to see how many are different sequences and go back to Bioedit and edit the count
# Discard alleles occuring less than 10 times

### this does not work: for CO06 no alleles have a count greater than 5. For CO13 thereare 826 alleles and for CO04 2227 alleles !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


## what if I use /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/*_uniq_ShortErased.fasta to directly only print alleles with a greater count than 10

## then individuals CO06, CO40,CO47, RO14, RO21 will have zero alleles (they have no so many alleles with counts than when sum up assuming that they are all equal alleles do not add to 10, so there is no point in taking a look at then in BioEdit)

##5 individuals (from most abundant populations anyway) need to be discarded. Not so bad.

##Apply first filter of min count 10 reads and then erase introns and inspect them in Bioedit.
workdir=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed
awk 'BEGIN {RS = ">" ; ORS = ""} $1 >= 10 {print ">"$0}' $workdir/LO05_uniq_ShortErased.fasta > $workdir/Filter_more10reads/LO05_more10.fasta

cutadapt -g file:$workdir/Introns2.fas -o $workdir/Filter_more10reads/LO05_more10_noIntron.fasta $workdir/Filter_more10reads/LO05_more10.fasta

## it is erasing part of the exon too!!!!!!!!


#I only applied filter to erase reads with coverage less than 10 
id=RO04
awk 'BEGIN {RS = ">" ; ORS = ">"} $0' $workdir/Filter_more10reads/EditNoIntron/${id}_more10_ed.fasta | cut -f 2 | sort | uniq -c | sort -n > $workdir/Filter_more10reads/EditNoIntron/Uniq/${id}_more10_edUniq.fasta

#did not work
workdir=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed



cat $workdir/Filter_more10reads/EditNoIntron/*.fasta > $workdir/Filter_more10reads/EditNoIntron/Uniq/cat_more10.fasta
### sequence is wrapped!!!
sed -e 's/\(^>.*$\)/#\1#/' $workdir/Filter_more10reads/EditNoIntron/cat_more10.fasta | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $workdir/Filter_more10reads/EditNoIntron/Uniqcat_more10_nw.fasta

paste - - < $workdir/Filter_more10reads/EditNoIntron/Uniq/cat_more10_nw.fasta> $workdir/Filter_more10reads/EditNoIntron/Uniq/cat_more10_oneline.txt


cut -f 2 $workdir/Filter_more10reads/EditNoIntron/cat_more10_oneline.txt | sort | uniq -c | sort -n > $workdir/Filter_more10reads/EditNoIntron/Uniq/cat_more10_oneline_uniq.txt

## name this alleles 
awk '{print "allele"NR"\t"$2}' $workdir/Filter_more10reads/EditNoIntron/Uniq/cat_more10_oneline_uniq.txt > $workdir/Filter_more10reads/EditNoIntron/Uniq/cat_more10_308alleles.txt
## and run loop Bruno to put that name in all individual files

#not wrapped
workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed'

end=$(wc -l $workdir/list_files_tab.txt | awk '{print $1}')
#end=2
for ((l=1; $l<=$end; l=$l+1)) ;do
    id=$(sed -n "${l}p" $workdir/list_files_tab.txt  | awk '{print $2}')
    sed -e 's/\(^>.*$\)/#\1#/' $workdir/Filter_more10reads/EditNoIntron/${id}_more10_ed.fasta | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $workdir/Filter_more10reads/EditNoIntron/NotWrapped/${id}_more10_edNW.fasta
done;



cd /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/Filter_more10reads/EditNoIntron/

./NameAlleles3.sh cat_more10_308alleles.txt /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/Filter_more10reads/EditNoIntron/NotWrapped/

workdir='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed'

path=$workdir/Filter_more10reads/EditNoIntron/AllelesNamed/
for indiv in $(ls $path);
do
    echo 'Processing file ' + $indiv
    output_file=AllelesNamed/$indiv
    input_search=$path/$indiv
    #make awk work in place using a tmp file
    awk '{print ">"$1"\n"$2}' $input_search > tmp && mv tmp $input_search
done



#### NEW RULE: based on verified alleles found with Binia's Rule. 9 H verified with the 2 rules (10% + more than 1 indiv). 47 alleles found only with 10% rule. 47-9=38 from those 38 discard those that only have 1 or 2 nt of dif with the 9 H (because they could be seq erros).


# fasta files in /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/ (Intron  remove, uniq sequences per indiv BUT STILL SOME SEQ WITH PART OF INTRON AND NO DELETIONS ADDED)
#edit them in Bioedit to find sequence 3 nt less to add de deletions

#Per INDIVIDUAL
#remove sequences that are not exactly 276 bp 
#not wrapped
workdir=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited
id=CO04
sed -e 's/\(^>.*$\)/#\1#/' $workdir/${id}_uniq_IntronRem_ed.fa | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $workdir/${id}_uniq_IntronRem_ed_nw.fasta

awk 'BEGIN{RS=">";ORS=""} length($2)==276{print ">"$0}' $workdir/${id}_uniq_IntronRem_ed_nw.fasta > $workdir/${id}_uniq_IntronRem_ed_nw_276bp.fasta

 
 #sort uniq again but sum count on col1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

paste - - < $workdir/${id}_uniq_IntronRem_ed_nw_276bp.fasta> $workdir/${id}_uniq_IntronRem_ed_nw_276bp_oneline.txt
#remove sign >
sed -i 's/[>]//g' $workdir/${id}_uniq_IntronRem_ed_nw_276bp_oneline.txt



#cut -f 2 $workdir/${id}_uniq_IntronRem_ed_nw_276bp_oneline.txt | sort | uniq -c | sort -n > $workdir/outfile

#rm -rf SumCount
#mkdir SumCount
#for indiv in $(ls $path);
#do
    #echo 'Processing file ' + $indiv
    #output_file=./AllelesNamed10Perc/$indiv
    #input_search=$path/$indiv
    #here put the awk sed and paste commands I use before and erase intermediate files at the end of loop
    LINE1=0
    for dna1 in $workdir/${id}_uniq_IntronRem_ed_nw_276bp_oneline.txt;
    do
        #((LINE1=LINE1+1))
        count1=$(echo $dna1 | awk '{print $1}')
        seq1=$(echo $dna1 | awk '{print $2}')
        LINE2=0

        GeneralCounter=$count1

        for dna2 in $workdir/${id}_uniq_IntronRem_ed_nw_276bp_oneline.txt;
        do
            echo "Analyzing sequence $dna"
            ((LINE2=LINE2+1))
            count2=$(echo $dna2 | awk '{print $1}')
            seq2=$(echo $dna2 | awk '{print $2}')
            if [[ "$LINE1" != "$LINE2" ]] && [[ "$seq1" == "$seq2" ]];
            then
                echo "duplicated sequences found, summing count"
                ((GeneralCounter=$GeneralCounter+$count2))
            fi;
        done
    echo -e "$GeneralCounter\t$seq1" >> $workdir/${id}_uniq_IntronRem_ed_nw_276bp_oneline_count.txt
    done
    
## does not work. Use SumCount.sh

### For all individuals

#path=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited
path=/import/kg_a2ews11/PC/TOMATE/prueba/

for indiv in $(ls $path);
do
    
    input_search=$path/$indiv
    nowrapped_file=./Prep/nw/$indiv
    length_file=./Prep/length/$indiv
    TAB_file=./Prep/TAB/$indiv
    #output_TABfile=./Prep/Infile_SumCount/$indiv
   
    sed -e 's/\(^>.*$\)/#\1#/' $input_search | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $nowrapped_file

    awk 'BEGIN{RS=">";ORS=""} length($2)==276{print ">"$0}' $nowrapped_file > $length_file
    
    paste - - < $length_file> $TAB_file
    sed -i 's/[>]//g' $TAB_file
done;

rm -r /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/nw/

rm -r /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/length/  


# now call bash ./SumCount_Ed2.sh
# outfiles in /import/kg_a2ews11/PC/TOMATE/prueba/Prep/TAB/out/

##very slow. To make it faster I separated infiles in different folders and run different slurm files (see infiles in /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/) and scripts in (/mnt/scratch/mathnat/ibb/dominguez/Scripts/) and slurm_submission files in (/mnt/scratch/mathnat/ibb/dominguez/Scripts/SlurmSubmit/)

# files in out folder are not sorted and col separated by space
# Convert space separated to tab separated
#(before doing this save files in hard disk just in case)

path='/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/'
for indiv in $(ls $path);
do
    echo 'Processing file ' + $indiv
    input_search=$path$indiv
    outputFreq_file=$path/Freq/Freq_${indiv}
        
    #replace space by tab
    awk '{$1=$1}1' OFS="\t" $input_search  > tmp && mv tmp $input_search
    #awk '{$1=$1}1' OFS="\t" $input_search  > ${path}Freq/$indiv
    
    #sort by col1
    sort -k1 -n $input_search > ${path}sorted_${indiv}
    
    
    #remove 10% lowest freq reads
    Perc=$(cat ${path}sorted_${indiv} | tail -n1 | awk '{print $1/10}')
    cat ${path}sorted_${indiv} | awk -v Perc="$Perc" '$1 >= Perc' > $outputFreq_file
done    
    
    #concatenate to have list of uniq sequences (haplotype file)
    
    #Freq
    cat $path/Freq/*.fa > $path/Freq/Hap_files/catFreq.txt  

    # to create a file with the total number of alleles
    cut -f 2 $path/Freq/Hap_files/catFreq.txt | sort | uniq -c | sort -n > $path/Freq/Hap_files/hapfile_10Perc.txt 
    #wc -l=  46
    
    #remove alleles that occur in only 1 indiv !!!!!!!!!!!!!!!!!!!
    awk '$1>1' $path/Freq/Hap_files/hapfile_10Perc.txt > $path/Freq/Hap_files/hapfile_10PercMore1Indiv.txt
    #wc -l= 8
    
    ############### before naming alleles discard those from the 46 that have only 1 or 2 nt difference with the 8 ones verified
    ############################################################################################
    
    # name haplotypes
    awk '{print "Allele"NR"\t"$2}' $path/Freq/Hap_files/hapfile_10Perc.txt > $path/Freq/Hap_files/hapfile_10Perc_names.txt
    awk '{print "vAllele"NR"\t"$2}' $path/Freq/Hap_files/hapfile_10PercMore1Indiv.txt > $path/Freq/Hap_files/hapfile_10PercMore1Indiv_names.txt
     
    # convert to fasta
    awk '{print ">"$1"\n"$2}' $path/Freq/Hap_files/hapfile_10Perc_names.txt > $path/Freq/Hap_files/hapfile_10Perc_names.fasta
    awk '{print ">"$1"\n"$2}' $path/Freq/Hap_files/hapfile_10PercMore1Indiv.txt > $path/Freq/Hap_files/hapfile_10PercMore1Indiv.fasta

    ## count numer of diferences between 46 alleles in $path/Freq/hapfile_10Perc.txt and the 8? alleles in $path/Freq/hapfile_10Perc_names.txt
    
    #I concatened the 2 hap_files and opened them in MEGA, then clic Distance (selected No of Differences). See the end of pariwise table generated. Saved as MEGA-PairwiseNoNtDifferences.xlsx
    # If I remove alleles with 2 nt differences with the verified Alleles: 24 Alleles (8 verified plus 16 new that appeared in only 1 individual.
    
    #List of Alleles (2nt diff removed):hapfile_names_2ntErased.fasta
   
    #unwrapped
    sed -e 's/\(^>.*$\)/#\1#/' $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased.fasta | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased_nw.fasta
   
    #convert to TAB
    paste - - < $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased_nw.fasta > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased.txt
    
    #List of Alleles (1nt diff removed, 2 nt diff accepeted):hapfile_names_1ntErased.fasta
    #unwrapped
    sed -e 's/\(^>.*$\)/#\1#/' $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased.fasta | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased_nw.fasta
   
    #convert to TAB
    paste - - < $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased_nw.fasta > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased.txt

   

    ##loop to change the name of allele in each individual fasta  
    ### maybe introduce here the filtering out the sequences with only 1 nt differencce (see NameAlleles_1ntDif.sh)
 
# 2nt diff removed
./NameAlleles_2ntDif.sh $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased.txt $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/

    
# 1nt diff removed

./NameAlleles_1ntDif.sh $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased.txt $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/

### Individual files (tab format) with alleles named in /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/AllelesNamed_1ntDif/
#or
#/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/AllelesNamed_2ntDif/

# 2nt diff removed
wc -l /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/AllelesNamed_2ntDif/*.fa | sort -g

# CO06 max number of alleles 7

# 1nt diff removed
wc -l /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/AllelesNamed_1ntDif/*.fa | sort -g

# CO06 max number of alleles 12
##########################################################################333

#### In how many individuals the alleles occur?
## this way with SumCount script or DNAsp program opening concatenated file

cd /mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/AllelesNamed_2ntDif

cat *.fa > cat_Freq2ntDif.txt
#to open with DNAsp and generate Haplotype Tabla, first transform to FASTA file
awk '{print ">"$1"\n"$2}' cat_Freq2ntDif.txt > cat_Freq2ntDif.fasta


vAllele8 45
vAllele7 27
vAllele6 13
vAllele5 8
vAllele4 5
vAllele3 5
vAllele2 2
vAllele1 2

#all the 24 nAlleles occur in only 1 individual

#### In how many individuals PER POP the alleles occur

cat Freq_CO* > cat_Freq2ntDif_CO.txt
awk '{print $1"\n"$2}' cat_Freq2ntDif_CO.txt > cat_Freq2ntDif_CO.fasta

cat Freq_LO* > cat_Freq2ntDif_LO.txt
awk '{print $1"\n"$2}' cat_Freq2ntDif_LO.txt > cat_Freq2ntDif_LO.fasta

cat Freq_RO* > cat_Freq2ntDif_RO.txt
awk '{print $1"\n"$2}' cat_Freq2ntDif_RO.txt > cat_Freq2ntDif_RO.fasta

cat Freq_SL* > cat_Freq2ntDif_SL.txt
awk '{print $1"\n"$2}' cat_Freq2ntDif_SL.txt > cat_Freq2ntDif_SL.fasta


# create list of unique sequences to allign to other species
#replace >> by > and then apply sort uniq

sed 's/>>/>/g' cat_Freq2ntDif.txt | sort -g | uniq > cat_Freq2ntDif_uniq.txt
awk '{print $1"\n"$2}' cat_Freq2ntDif_uniq.txt > cat_Freq2ntDif_uniq.fasta


########################################
### CONVERT TAB TO FASTA
awk '{print ">"$1"\n"$2}' file

### CONVERT FASTA TO tabular
paste - - < file > filenew

### unwrap
sed -e 's/\(^>.*$\)/#\1#/' infile.fasta | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > outfile_nw.fasta

#count number of sequences in fasta file
grep -c "^>" file.fa
#######################################

##producing bioedit alignment for publication ###
https://labs.mcdb.ucsb.edu/weimbs/thomas/sites/labs.mcdb.ucsb.edu.weimbs.thomas/files/docs/multiplesequencealignmenttutorial.pdf
