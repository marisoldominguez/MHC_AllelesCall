#!/bin/sh

hap_file=$1
path=$2
rm -rf AllelesNamed_1ntDif
mkdir AllelesNamed_1ntDif
for indiv in $(ls $path);
do
    echo 'Processing file ' + $indiv
    output_file=$HPC_SCRATCH/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/Freq/AllelesNamed_1ntDif/$indiv
    input_search=$path/$indiv
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
done;


    
