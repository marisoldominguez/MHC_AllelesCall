#!/bin/sh

hap_file=$1
path=$2
rm -rf AllelesNamed10Perc1Indiv
mkdir AllelesNamed10Perc1Indiv
for indiv in $(ls $path);
do
    echo 'Processing file ' + $indiv
    output_file=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/LowFreq/LowFreqFasta/Fasta/FastaToTab/fasta/AllelesNamed10Perc1Indiv/$indiv
    input_search=$path/$indiv
    #paste - - < $input_search > temp
    for dna in $(awk '{print $2}' $input_search);
    do
        #echo $dna
        search_result=$(grep $dna $hap_file);
        #echo $search_result
        
        if [ "$search_result" ];
        then
        
            #output=$(grep $dna $input_search);
            echo $search_result >> $output_file
        fi;
    done;
rm -f temp
done;


    
