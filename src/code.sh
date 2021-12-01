#!/bin/bash
# ngc_SMNCopyNumberCaller 1.1.1
# Generated by dx-app-wizard.
#
# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://documentation.dnanexus.com/developer for tutorials on how
# to modify this file.

main() {

    echo "Value of input_bam_file: '${input_bam_file[@]}'"
    echo "Value of smn_docker: '$smn_docker'"

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".

    dx download "$smn_docker" -o smncopynumbercaller_v1.1.1.tar.gz
    
    docker load -i "$smn_docker_path"

    for i in ${!input_bam_file[@]}
    do
        dx download "${input_bam_file[$i]}"
        echo "Input BAM file Downloaded" 
        cmd="dx describe '${input_bam_file[$i]}' --name"
        echo $cmd
        BamFileName=$(eval $cmd)
        echo "Filename is $BamFileName"        

        #Create temp file to input BAM file path to SMNCaller
        touch /home/dnanexus/bam_file_path_tmp.txt
        echo "/home/dnanexus/$BamFileName" > /home/dnanexus/bam_file_path_tmp.txt

        # Load the docker image and then run SMNCaller
        docker load -i /home/dnanexus/in/smn_docker/smncopynumbercaller_v1.1.1.tar.gz
        docker run -v /home/dnanexus:/myfiles clinicalgenomics/smncopynumbercaller:v1.1.1 python /opt/conda/bin/smn_caller.py --manifest /myfiles/bam_file_path_tmp.txt --genome 37 --outDir /myfiles/ --prefix $BamFileName
    done
    # Upload results
    dx-upload-all-outputs --parallel

    #remove tmp file
    /home/dnanexus/bam_file_path_tmp.txt
}
