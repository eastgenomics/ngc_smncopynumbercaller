#!/bin/bash
## SMNCallerPipeline.sh

BamFile="/myfiles/bam.txt";

#Reading bam file
while read -r line
do

# Run SMNCaller
touch /myfiles/tmp.txt
echo "$line" > /myfiles/tmp.txt

#for i in `cut -f1 -d' ' $new_families`; do echo "mkdir -p ${analysis_dir}/${i}/SMA/${release}/ && grep $i NGC/us/release/${release}/manifest/manifest.txt | cut -f10 > ${analysis_dir}/${i}/SMA/${release}/bams.fof && ~/bin/python3-env/bin/python3 ${SMN_dir}/smn_caller.py --manifest ${analysis_dir}/${i}/SMA/${release}/bams.fof --genome $SMN_refgen --outDir ${analysis_dir}/${i}/SMA/${release}/ --prefix $i | tee ${release_dir}/${release}/logs/${i}.SMNCaller.log"; done | nice parallel --will-cite -j 8
python /opt/conda/bin/smn_caller.py --manifest /myfiles/tmp.txt --genome 37 --outDir /myfiles/ --prefix $line

# Make plots
#for i in `cut -f1 -d' ' $new_families`; do echo "~/bin/python3-env/bin/python3 ${SMN_dir}/smn_charts.py -s ${analysis_dir}/${i}/SMA/${release}/${i}.json -o ${analysis_dir}/${i}/SMA/${release}/"; done | nice parallel --will-cite -j 8
#python /opt/conda/share/SMNCopyNumberCaller-1.1.1/smn_charts.py -s /myfiles/smn_results/NA12878.json -o /myfiles/smn_results

# Copy to filtering directory if True SMA call
#for i in `cut -f1 -d' ' $new_families`; do touch ${analysis_dir}/${i}/filtering/${i}.SMA_${release}.txt && s=`awk -F'\t' '{ if ($2 == "True") { print } }' ${analysis_dir}/${i}/SMA/${release}/$i.tsv | wc -l | cut -f1 -d' '` && if [ $s != 0 ]; then cat ${analysis_dir}/${i}/SMA/${release}/$i.tsv > ${analysis_dir}/${i}/filtering/${i}.SMA_${release}.txt; fi; done
done < "$BamFile"

rm /myfiles/tmp.txt
echo "SMNCaller pipeline done"