
if [ "$*" == "" ]; then
    echo "Enter output file name"
    exit 1
else
   opfile=$1
fi


mkdir RESULT >/dev/null 2>&1
mkdir graph >/dev/null 2>&1
for text in *.log; do 
export text
export STALL
export opfile
export bf
echo "file: $text"
STALL="$(grep -o 'Stalling' $text | wc -l)"
#echo $STALL
#sed -i '/Executed/,$!d' $text
bf="$(awk '{for(i=1;i>0&&i<=NF;i++) if ($i=="<---BufferCapacity--->"){ print $(i+1); exit;}}' $text)"
#echo "bf: $bf"
sed -i.bak '/videoBitrate/!d' $text
awk -F'"' '$0=$2' $text > testfile.tmp && mv testfile.tmp $text
sed -i.bak  $text -e 's/^[^:]*:/:/' 
sed -i.bak  $text -e 's/\://g'
awk '{print $0, " " $8}' $text > testfile.tmp && mv testfile.tmp $text
awk '{if(NR == 1) {shift = $2}print $0, " " (($2 - shift)/1000)}' $text > testfile.tmp && mv testfile.tmp $text
awk '{$2=$10;  print}' $text > testfile.tmp && mv testfile.tmp $text
awk '{$10 = "" ;  print}' $text > testfile.tmp && mv testfile.tmp $text
awk '{tmp = $9; $9 = prev; prev = tmp; print}' $text > testfile.tmp && mv testfile.tmp $text
awk '{if(NR == 1) print $0, " " 0;  else print $0; }'  $text > testfile.tmp && mv testfile.tmp $text
awk '{if($8==$9) print $0, " " 0;  else {print $0, " " $8;} }'  $text > testfile.tmp && mv testfile.tmp $text
awk '{$9= " "; print $0; }'  $text > testfile.tmp && mv testfile.tmp $text
awk '{if(NR == 1){$9=0; print $0; } else print $0; }'  $text > testfile.tmp && mv testfile.tmp $text
awk '{if($8 == "Infinity"){$8=0; $9=0; print $0; } else print $0; }' $text > testfile.tmp && mv testfile.tmp $text

#./t.r $text
./zqoe.sh $text
done
./csvCreate.sh RESULT/$opfile

for f1 in *.log; do 
rm $f1
done

for f2 in *.bak; do 
rm $f2
done


echo "check RESULT and graph directory for output"
