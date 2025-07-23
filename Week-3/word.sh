#!/bin/bash


filename="file.txt"

#check if the file exist
if [ ! -f "$filename" ]; then
  echo "Error: File '$filename' not found."
  exit 1
fi

#print the number of words
echo "Total number of lines in $filename: $(wc -w < $filename)"

#print the number of lines
echo "Total number of lines in $filename: $(wc -l < $filename)"

#print the number of characters
echo "Total number of character in $filename: $(wc -m < $filename)"

#print size of the file
echo "File size: $(du -h $filename)"
