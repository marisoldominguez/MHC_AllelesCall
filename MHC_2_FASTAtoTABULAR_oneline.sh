### CONVERT FASTA TO tabular
inpath=$1
outpath=$2

for file in $(ls $inpath);
do
    id=$(echo $file | awk -F_ '{print $2}')
    paste - - < $inpath/MaD_${id}_Refined_PrimerRemRev.fa> $outpath/${id}_oneline.fa
done


