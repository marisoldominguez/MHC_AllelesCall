# formatting and calling alleles by RULE 1 again (10% freq)

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

################
## Re call Alleles 10% Freq + more than in 1 Individual

#concatenate to have list of uniq sequences 
    
#Freq
cat $path/Freq/*.fa > $path/Freq/Hap_files/catFreq.txt  

# to create a file with the total number of alleles
cut -f 2 $path/Freq/Hap_files/catFreq.txt | sort | uniq -c | sort -n > $path/Freq/Hap_files/hapfile_10Perc.txt 
#wc -l=  46

    
#remove alleles that occur in only 1 indiv
awk '$1>1' $path/Freq/Hap_files/hapfile_10Perc.txt > $path/Freq/Hap_files/hapfile_10PercMore1Indiv.txt
#wc -l= 8


############### before naming alleles discard those from the 46 that have only 1 or 2 nt difference with the 8 ones verified ##################

# name haplotypes
awk '{print "Allele"NR"\t"$2}' $path/Freq/Hap_files/hapfile_10Perc.txt > $path/Freq/Hap_files/hapfile_10Perc_names.txt

awk '{print "vAllele"NR"\t"$2}' $path/Freq/Hap_files/hapfile_10PercMore1Indiv.txt > $path/Freq/Hap_files/hapfile_10PercMore1Indiv_names.txt
     
# convert to fasta
awk '{print ">"$1"\n"$2}' $path/Freq/Hap_files/hapfile_10Perc_names.txt > $path/Freq/Hap_files/hapfile_10Perc_names.fasta

awk '{print ">"$1"\n"$2}' $path/Freq/Hap_files/hapfile_10PercMore1Indiv.txt > $path/Freq/Hap_files/hapfile_10PercMore1Indiv.fasta
    
## Use MEGA to count number of diferences between alleles

 
#unwrapped
sed -e 's/\(^>.*$\)/#\1#/' $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased.fasta | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased_nw.fasta
   
#convert to TAB
paste - - < $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased_nw.fasta > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased.txt
    
#List of Alleles (1nt diff removed, 2 nt diff accepted):hapfile_names_1ntErased.fasta
#unwrapped
sed -e 's/\(^>.*$\)/#\1#/' $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased.fasta | tr -d "\r" | tr -d "\n" | sed -e 's/$/#/' | tr "#" "\n" | sed -e '/^$/d'  > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased_nw.fasta
   
#convert to TAB
paste - - < $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased_nw.fasta > $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased.txt

# 2nt diff removed
./NameAlleles_2ntDif.sh $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_2ntErased.txt $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/

    
# 1nt diff removed

./NameAlleles_1ntDif.sh $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/Hap_files/hapfile_names_1ntErased.txt $HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/
