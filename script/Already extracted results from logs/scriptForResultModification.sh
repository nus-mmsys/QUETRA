#!/bin/bash



text=$1

export text
export newtext
echo "file: $text"
awk '{print $1, " "$15" "$18" "$9" "$7" "$20" "$22" "$24" "$26}'  $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("buff"," ", $1) ' $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("-"," ", $1) ' $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("log"," ", $3) ' $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("\."," ", $3) ' $text > testfile.tmp && mv testfile.tmp $text
sort -t 't' -k1,1 -k2,2 -k3,3 $text > testfile.tmp && mv testfile.tmp $text
awk 'BEGIN{print "profile sample method bitrate change ineff stall numStall avgStall overflow numOverflow"}{print $0}'  $text > testfile.tmp && mv testfile.tmp $text

