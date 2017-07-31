#!/bin/bash



text=$1


n=${text%.*}
b=$n"-backup.log"
n+=".csv"
cp $text $b
export text
export newtext
echo "file: $text"
awk '{print $1, " "$15" "$18" "$9" "$7" "$20" "$22" "$24" "$26" "$34" "$36}'  $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("event"," ", $1) ' $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("-"," ", $1) ' $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("csv"," ", $3) ' $text > testfile.tmp && mv testfile.tmp $text
awk ' gsub("\."," ", $3) ' $text > testfile.tmp && mv testfile.tmp $text
sort -t 't' -k1,1 -k2,2 -k3,3 $text > testfile.tmp && mv testfile.tmp $text
awk 'BEGIN{print "profile sample method bitrate change ineff stall numStall avgStall overflow numOverflow qoe bufSize"}{print $0}'  $text > testfile.tmp && mv testfile.tmp $text
awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13}'  $text > testfile.tmp && mv testfile.tmp $n

