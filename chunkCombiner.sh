#!/bin/bash

function usage {
    echo "Usage: $(basename $0) [-d -o]"
    echo "  Mandatory Flags."
    echo "    -d    Absolute path to Sharry filesystem database directory."
    echo "    -o    Absolute path to directory to output rebuilt files."
    echo "  Other Flags."
    echo "    -h    Show usage."
#    echo "    -e    File type extensions you want to rebuild."     
    exit 1
}

if (($# == 0)); then
    echo "Error: Mandatory Flags missing.";
    usage;
fi

optstring=":d:o:h";

while getopts ${optstring} arg; do
    case "${arg}" in
        d) databaseDir=${OPTARG} ;;
        o) outputDir=${OPTARG} ;;
#	e) echo "Not yet implemented." ;;
        h) usage ;;
        :) echo "Error: Missing option argument for -${OPTARG}."
           usage ;;
        ?) echo "Error: Invalid option: - ${OPTARG}."
           usage ;;
    esac
done

if [ ! -d $databaseDir ]; then
    echo "Error: Invalid database directory.";
    usage;
fi

if [ ! -d $outputDir ]; then
    echo "Output directory $outputDir not found.";
    echo "Create directory $outputDir and continue? [Y/N]";
    read input;
    if [[ $input == "Y" || $input == "y" ]]; then
        mkdir $outputDir;
	echo "Created directory $outputDir.";
    elif [[ $input == "N" || $input == "n" ]]; then
	echo "Exiting.";
	exit 0;
    else
	echo "Invalid [Y/N] input.";
	echo "Exiting.";
	exit 1;
    fi
fi

echo "Generating list of data directories.";
dirListPath=$outputDir/dirList
find $databaseDir -type f -exec dirname {} >> $dirListPath.tmp +;
awk '!a[$0]++' $dirListPath.tmp >> $dirListPath.txt;
rm $dirListPath.tmp;

echo "Reading in MIME type dictionary.";
declare -A extByType;
while read -r line; do
    mimeType=$(echo $line | cut -d "|" -f 1);
    ext=$(echo $line | cut -d "|" -f 2);
    extByType[$mimeType]="$ext";
done < extByMimeType.txt

#Get padded zero count for filename
fileCount=$(wc -l < $dirListPath.txt);
digitCount=${#fileCount};
i=0;

#Combine chunks and assign extension
while read -r line; do
    ((i=i+1));
    cd "$line" ; cat ~+/* >> $line/output.tmp;
    mimeType=$(file -b --mime-type output.tmp);
    extension=${extByType[$mimeType]};
    paddedInt=$(printf "%0${digitCount}d" ${i});
    mv output.tmp $outputDir/file_$paddedInt$extension;
    echo -ne "File $i/$fileCount rebuilt.\r";
done <$dirListPath.txt

rm $dirListPath.txt
echo "File $i/$fileCount rebuilt.";
