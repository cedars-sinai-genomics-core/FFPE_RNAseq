#cd $1
#project=$2
#config="/home/genomics/genomics/apps/multiqc/multiqc_config_example.yaml"

#copy the FFPE_mRNA_results_generation file to the corresponding project folder and create a folder called results
#before running this file, please run this file before running the count matrix generation bash file
cd results


for dir in */
do 
dir="$dir"
sample=$(echo $dir | cut -d'_' -f 1)
suffix="_fastq_gz"
sampleName=${sample%"$suffix"}
suffix2="_R1.txt"
suffix3="_R1_trimmed.fastq_clean_fastqc.html"
suffix4="_R1_trimmed.fastq_clean_fastqc"
suffix5="_R1_trimmed.fastq_clean_fastqc.zip"
cd $dir
cd rseqc*
mv read* ..
cd ..
mv read_distribution.txt $sampleName$suffix2 
find . -mindepth 2 -type f -print -exec mv {} . \;
gunzip fastqc_files.tar.gz
tar -xvf fastqc_files.tar
mv *clean_fastqc.html *temp_fastqc.html
sed 's/UMI_//g' *temp_fastqc.html > $sampleName$suffix3
rm *temp_fastqc.html
unzip *.fastq_clean_fastqc.zip
cd *fastq_clean_fastqc
sed 's/UMI_//g' fastqc_report.html > fastqc_report_temp.html
rm fastqc_report.html
mv fastqc_report_temp.html fastqc_report.html
sed 's/UMI_//g' fastqc_data.txt > fastqc_data_temp.txt
rm fastqc_data.txt
mv fastqc_data_temp.txt fastqc_data.txt
cd ..
rm *clean_fastqc.zip
mv *clean_fastqc  $sampleName$suffix4
zip -r $sampleName$suffix5 $sampleName$suffix4
rm *.png
cd ..
done
qsub -q all.q -N multiqc_generate -cwd /common/genomics-core/apps/mapping_qc_auto/multiqc.sh test_Xinling
mkdir multiqc 
mv *multiqc_data multiqc 
mv *.multiqc.html multiqc 
mv multiqc_generate* multiqc 
mv multiqc ..


