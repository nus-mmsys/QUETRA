#!/bin/bash



text=$1

export text
export newtext
echo "file: $text"
awk '{if($3!="abr" && $3!="kama" && $3!="gd" && $3!="dy" && $3!="ra")print $0}' $text > testfile.tmp && mv testfile.tmp $text




