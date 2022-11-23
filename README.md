# sharry-chunk-combiner
[Sharry](https://github.com/eikek/sharry) doesn't have a "Download all" option at present.  
This bash script recombines the locally stored database chunks back into complete files to avoid manually downloading files.

### Example
<p align="Left">
<img align="center" src="/demo.gif" alt="Demo of Script" title="Demo of Script" <br \>
</p>

## Why make this?
I hosted a Sharry instance for wedding guests to upload photos and videos. Then I had hundreds of files and had to click download on each individually. The file data was on the server, just in chunks. Now I can point this script at the database directory and it will combine the chunks back into files.

## How to use?
0. [Backup your data](#0-backup-your-data)
1. [Check Sharry configuration](#1-check-sharry-configuration)
2. [Clone this repo](#2-clone-this-repo)
3. [Run script](#3-run-the-script)

### 0. Backup your data
Backup your database before you let a script loose on it.

### 1. Check Sharry configuration
Your Sharry instance needs to be configured to [use local filesystem](https://eikek.github.io/sharry/doc/configure#files) for file storage. If you already have the files configured with a different database, [change file store.](https://eikek.github.io/sharry/doc/configure#changing-file-stores)

### 2. Clone this repo
```
git clone https://github.com/mpdcampbell/sharry-chunk-combiner.git
```
### 3. Run the script
Make the script executable.
```
chmod +x chunkCombiner.sh
```
The script requires two input arguments to work, -d and -o, explained below.
```
Usage: chunkCombiner.sh [-d -o -h]
  Mandatory Flags.
    -d    Path to Sharry filesystem database directory.
    -o    Path to directory to output rebuilt files.
  Other Flags.
    -h    Show usage.
```
So for example run the script with:
```
./chunkCombiner.sh -d ~/sharryDatabase/ -o outputDirectory
```

## Limitations
The script has a few main limitations:
 - Original filenames are lost.
 - If the file mime-type isn't in the dictionary, it wont be assigned. The file will still be rebuilt just without an extension.
 - It uses associate arrays, added with Bash 4.0 in 2009. By default Mac OS only has Bash 3.2 [because of licensing](https://thenextweb.com/news/why-does-macos-catalina-use-zsh-instead-of-bash-licensing). 
