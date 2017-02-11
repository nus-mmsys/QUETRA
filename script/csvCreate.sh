#!/bin/bash



text=$1


n=${text%.*}
b=$n"-backup.log"
n+=".csv"
cp $text $b
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
sed -i 's/ql30/quetra/' $text
sed -i 's/ql120/quetra/' $text
sed -i 's/ql240/quetra/' $text
sed -i 's/bb30/bba/' $text
sed -i 's/bb120/bba/' $text
sed -i 's/bb240/bba/' $text
awk '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11}'  $text > testfile.tmp && mv testfile.tmp $n

