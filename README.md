# sharry-chunk-combiner
[Sharry](https://github.com/eikek/sharry) doesn't have a "Download all" option at present.  
This bash script recombines the locally stored database chunks back into complete files to avoid manually downloading files.

## Why make this?
I hosted a Sharry instance for our wedding guests to upload photos and videos. Then I had hundreds of files and realised I had to click download on each individually. The file data was on the server, just in chunks. Point this script at the database directory and it will combine the chunks back into files.

## How to use it?

## Limitations
This a basic bash script, it has a couple main limitations:
 - Original filenames are lost.
 - If the file extension isn't in the dictionary, it wont be assigned. The file will still be rebuilt just named with no extension.
 - It uses associate arrays, added in Bash 4.0 in 2009. By default Mac OS only has Bash 3.2, [because of licensing](https://thenextweb.com/news/why-does-macos-catalina-use-zsh-instead-of-bash-licensing). 
