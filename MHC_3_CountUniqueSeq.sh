path=$1
mkdir=$path/uniq

for file in $(ls $path);
do
    id=$(echo $file | awk -F_ '{print $2}')
    cut -f 2 $path/${id}_oneline.fa | sort | uniq -c | sort -n > $path/uniq/${id}_uniq.txt
done

