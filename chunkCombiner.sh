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
