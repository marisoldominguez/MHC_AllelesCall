#!/bin/sh

path=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/
for indiv in $(ls $path);
do
    echo 'Processing file ' + $indiv
    output_file=/mnt/scratch/mathnat/ibb/dominguez/PrimersRemoved/MHCI_Q20/withoutReverse/oneline/uniq/ed/IntronRemoved/IntronRemoved_Edited/Prep/TAB/out/$indiv
    input_search=$path$indiv

    current_line1=0
    while read dna1;
    do  
        count1=$(echo $dna1 | awk '{print $1}')
        seq1=$(echo $dna1 | awk '{print $2}')
        current_line2=0

        dna_general_sum=$count1	

        while read dna2;
        do
            count2=$(echo $dna2 | awk '{print $1}')
            seq2=$(echo $dna2 | awk '{print $2}')

            echo $current_line1
            echo $current_line2

            if [ "$current_line1" != "$current_line2" ] && [ "$seq1" = "$seq2" ]
            then
                echo 'I found a duplicated shit thing'
                dna_general_sum=$((dna_general_sum+$count2))
            fi

            current_line2=$((current_line2+1))
        done < $input_search

        already_there=$(grep $seq1 $output_file);

        if [ ! "$already_there" ]
        then
            echo $dna_general_sum $seq1 >> $output_file
        fi

        current_line1=$((current_line1+1))
    done < $input_search
done;
