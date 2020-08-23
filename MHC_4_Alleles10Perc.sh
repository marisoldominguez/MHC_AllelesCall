### RULE 1 FOR CALLING ALLELES

# Discard 10% lowest freq reads
## if max count is 1861, then remove all sequences ocurring less than 186 times

inpath=$1
outpath=$2

for file in $(ls $inpath);
do
    id=$(echo $file | awk -F_ '{print $2}')
    Perc=$(cat $inpath/${id}_uniq.txt | tail -n1 | awk '{print $1/10}')
    cat $inpath/${id}_uniq.txt | sed -e 's/^[ \t]*//' | awk -v Perc="$Perc" '$1 >= Perc' > $outpath/${id}_uniq_lowfreq.txt
done


