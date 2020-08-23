 #### NEW RULE: 9 verified alleles found with the 2 rules (10% + more than 1 indiv). 47 alleles found only with 10% rule. 47-9=38 from those 38 discard those that only have 1 or 2 nt of dif with the 9 H (because they could be seq erros).

##################################
# aditional cleaning of alleles call
##################################


##edit them in Bioedit to find sequence 3 nt less to add de deletions

##remove sequences that are not exactly 276 bp 

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

