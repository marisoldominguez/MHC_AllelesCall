### script to remove primers using cutadapt software

inpath=$1
outpath1=$2

for file in $(ls $inpath);
do
    id=$(echo $file | awk -F_ '{print $2}')
    cutadapt -a ^CCATGGGTCTCTGTGGGTA...GGTGDGARCAGAATTMYTGWG -o $outpath1/MaD_${id}_Refined_PrimerRem.fa $inpath/MaD_${id}_Refined.fa
done




### command to delete  leftovers of reverse primer

outpath2=$3

for file in $(ls $outpath1);
do
    id=$(echo $file | awk -F_ '{print $2}')
    cutadapt -a GGTGDGARCAGAATTMYTGWG -o $outpath2/MaD_${id}_Refined_PrimerRemRev.fa $outpath1/MaD_${id}_Refined_PrimerRem.fa
done
