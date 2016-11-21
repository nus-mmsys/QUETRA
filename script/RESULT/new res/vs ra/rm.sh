#!/bin/bash



text=$1

export text
export newtext
echo "file: $text"
awk '{if($3!= "ar") print $0;}' $text > testfile.tmp && mv testfile.tmp $text
awk '{if($3!= "kama") print $0;}' $text > testfile.tmp && mv testfile.tmp $text
awk '{if($3!= "gd") print $0;}' $text > testfile.tmp && mv testfile.tmp $text
awk '{if($3!= "dy") print $0;}' $text > testfile.tmp && mv testfile.tmp $text
