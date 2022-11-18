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

#Dictionary of mime-type and extension

extByType[jpeg]=.jpeg
extByType[png]=.png
extByType[quicktime]=.qt
extByType[mp4]=.mp4

i=0;
while read -r line; do
    cd "$line" ; cat ~+/* >> $line/output.tmp;
    mimetype=$(file -b --mime-type output.tmp | cut -d "/" -f 2);
    extension=${extByType[$mimetype]};
    mv output.tmp $outputDir/file_$i$extension;
    ((i=i+1));
done <$dirListPath.txt

rm $dirListPath.txt
