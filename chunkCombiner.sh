#! /bin/bash

#Directory Paths
databaseDir=$databaseDir
dirList="dirList"
dirListPath=$dirListPath
outputDir=$outputDir

#List lowest level directories with chunks
find $databaseDir -type f -exec dirname {} >> $dirListPath.tmp +;
awk '!a[$0]++' $dirListPath.tmp >> $dirListPath.txt;
rm $dirListPath.tmp;

if [ ! -d $outputDir ]; then
    mkdir $outputDir;
fi

#Read in dictionary of mime-type and extension
declare -A extByType;
while read -r line; do
    mimetype=$(echo $line | cut -d "|" -f 1);
    ext=$(echo $line | cut -d "|" -f 2);
    extByType[$mimetype]="$ext";
done < extByMimeType.txt

#Get padded zero count for filename
fileCount=$(wc -l < $dirListPath.txt);
digitCount=${#fileCount};
i=1;

#Combine chunks and assign extension
while read -r line; do
    cd "$line" ; cat ~+/* >> $line/output.tmp;
    mimetype=$(file -b --mime-type output.tmp | cut -d "/" -f 2);
    extension=${extByType[$mimetype]};
    paddedInt=$(printf "%0${digitCount}d" ${i});
    mv output.tmp $outputDir/file_$paddedInt$extension;
    ((i=i+1));
done <$dirListPath.txt

rm $dirListPath.txt
