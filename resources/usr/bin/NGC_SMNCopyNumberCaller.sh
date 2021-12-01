#!/bin/bash
## dnanexus-app ngc_SMNCopyNumberCaller

##############
#Title: SMNCopyNumberCaller 
#Discription: SMNCopyNumberCaller is a tool to call the copy number of full-length SMN1, full-length SMN2, as well as SMN2Δ7–8 (SMN2 with a deletion of Exon7-8) from a whole-genome sequencing (WGS) BAM file. 
#Version: 1.1.1 
#Author: Dr. Ravi P. More (Research Associate, Department of Paediatrics, University of Cambridge, Email: Ravi.More@addenbrookes.nhs.ac.uk)
#Date: 01-12-2021 
#USAGE: NGC_SMNCopyNumberCaller.sh -i <BAM_FILE_LIST>.txt
#Example: NGC_SMNCopyNumberCaller.sh -i bam.txt
##################

while getopts i: flag
do
    case "${flag}" in
        i) BamFile=${OPTARG};;        
    esac
done

echo "Input BAM file name: $BamFile";
#BamFile="/home/dnanexus/bam.txt";

#Reading bam file
while read -r line
do

# Run SMNCaller
touch /home/dnanexus/tmp.txt
echo "$line" > /home/dnanexus/tmp.txt

#for i in `cut -f1 -d' ' $new_families`; do echo "mkdir -p ${analysis_dir}/${i}/SMA/${release}/ && grep $i NGC/us/release/${release}/manifest/manifest.txt | cut -f10 > ${analysis_dir}/${i}/SMA/${release}/bams.fof && ~/bin/python3-env/bin/python3 ${SMN_dir}/smn_caller.py --manifest ${analysis_dir}/${i}/SMA/${release}/bams.fof --genome $SMN_refgen --outDir ${analysis_dir}/${i}/SMA/${release}/ --prefix $i | tee ${release_dir}/${release}/logs/${i}.SMNCaller.log"; done | nice parallel --will-cite -j 8
docker run -v /home/dnanexus:/myfiles clinicalgenomics/smncopynumbercaller:v1.1.1 python /opt/conda/bin/smn_caller.py --manifest /myfiles/tmp.txt --genome 37 --outDir /myfiles/ --prefix $line

# Make plots
#for i in `cut -f1 -d' ' $new_families`; do echo "~/bin/python3-env/bin/python3 ${SMN_dir}/smn_charts.py -s ${analysis_dir}/${i}/SMA/${release}/${i}.json -o ${analysis_dir}/${i}/SMA/${release}/"; done | nice parallel --will-cite -j 8
#python /opt/conda/share/SMNCopyNumberCaller-1.1.1/smn_charts.py -s /myfiles/smn_results/NA12878.json -o /myfiles/smn_results

# Copy to filtering directory if True SMA call
#for i in `cut -f1 -d' ' $new_families`; do touch ${analysis_dir}/${i}/filtering/${i}.SMA_${release}.txt && s=`awk -F'\t' '{ if ($2 == "True") { print } }' ${analysis_dir}/${i}/SMA/${release}/$i.tsv | wc -l | cut -f1 -d' '` && if [ $s != 0 ]; then cat ${analysis_dir}/${i}/SMA/${release}/$i.tsv > ${analysis_dir}/${i}/filtering/${i}.SMA_${release}.txt; fi; done
done < "$BamFile"

rm /home/dnanexus/tmp.txt
echo "SMNCopyNumberCaller pipeline done"