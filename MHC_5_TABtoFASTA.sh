## TAB to FASTA

inpath=$1
outpath=$2

for file in $(ls $inpath);
do
    id=$(echo $file | awk -F_ '{print $2}')
    awk '{print ">"$1"\n"$2}' /$inpath/${id}_uniq_lowfreq_ed.txt > /$outpath/${id}_uniq_lowfreq_ed.fasta
done

# In Bioedit manually inspect and erase introns and sequence that are too short 
