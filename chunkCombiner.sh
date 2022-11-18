#! /bin/bash

#Directory Paths
databaseDir=$databaseDir
dirList="dirList"
dirListPath=$dirListPath
outputDir=$outputDir

find $databaseDir -type f -exec dirname {} >> $dirListPath.tmp +;
awk '!a[$0]++' $dirListPath.tmp >> $dirListPath.txt;
rm $dirListPath.tmp;

head -5 $dirListPath.txt
wc -l < $dirListPath.txt

if [ ! -d $outputDir ]; then
    mkdir $outputDir;
fi

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

while read -r line; do
    cd "$line" ; cat ~+/* >> $line/output.tmp;
    mimetype=$(file -b --mime-type output.tmp | cut -d "/" -f 2);
    extension=${extByType[$mimetype]};
    echo $extension;
    paddedInt=$(printf "%0${digitCount}d" ${i});
    mv output.tmp $outputDir/file_$paddedInt$extension;
    ((i=i+1));
done <$dirListPath.txt

rm $dirListPath.txt
