#!/bin/bash

#File Paths
databaseDir= #ENTER PATH TO DATABASE DIRECTORY eg /home/user/sharrydb/
outputDir= #ENTER PATH TO DIRECTORY TO OUTPUT RECOMBINED FILES
dirListPath=$outputDir/dirList

#Check variables were updated
if [ -z "$databaseDir" ]; then
  echo "Error: The databaseDir variable is empty, exiting script."
  exit 1
elif [ -z "$outputDir" ]; then
  echo "Error: The outputDir variable is empty, exiting script."
  exit 1
fi

if [ ! -d $outputDir ]; then
    mkdir $outputDir;
fi

echo "Generating list of data directories.";
find $databaseDir -type f -exec dirname {} >> $dirListPath.tmp +;
awk '!a[$0]++' $dirListPath.tmp >> $dirListPath.txt;
rm $dirListPath.tmp;

echo "Reading in MIME type dictionary.";
declare -A extByType;
while read -r line; do
    mimeType=$(echo $line | cut -d "|" -f 1);
    ext=$(echo $line | cut -d "|" -f 2);
    extByType[$mimetype]="$ext";
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
