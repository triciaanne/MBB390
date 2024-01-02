fasta_file=$1
sample_name=$2

mkdir ${sample_name}_viruses_classifier
mkdir ${sample_name}_viruses_classifier/separated_fasta_files

echo "=====Separating FASTA entries into individual files====="

while read line
do
	if [[ ${line:0:1} == '>' ]]
	then
		outfile=${line#>}.fa
		echo ${line} > ${sample_name}_viruses_classifier/separated_fasta_files/${outfile}
	else
		echo ${line} >> ${sample_name}_viruses_classifier/separated_fasta_files/${outfile}
	fi
done < $1

echo "=====Running viruses_classifier====="

i=1

for file in ${sample_name}_viruses_classifier/separated_fasta_files/*
do
	echo "===Entry number: ${i}==="
	i=$((i+1))

	pred_out=$(viruses_classifier ${file} --nucleic_acid DNA --classifier SVC)

	file1=${file%%.*}
	file2=${file1##*/}

	echo -e "${file2}\t${pred_out}" | tee -a ${sample_name}_viruses_classifier/${sample_name}_viruses_classifier.out
done

