
if [ "$*" == "" ]; then
    echo "Enter output file name"
    exit 1
else
   opfile=$1
fi


mkdir RESULT >/dev/null 2>&1
eventDir=${opfile%.*}
mkdir graph/$eventDir >/dev/null 2>&1
for text in 30-60/*.log 120/*.log 240/*.log ; do 
	export event
	export STALL
	export opfile
	n=${text%.*}
        m=${n%/*}
        o=${n#*/}
        mkdir $m"_events" >/dev/null 2>&1
        newtext=$o".tmp"
        event="event-"$o".csv"
        status="Playing"
        cp $text $newtext
        text=$newtext
        echo "file: $text"
	STALL="$(grep -o 'Stalling' $text | wc -l)"
	#echo $STALL
	#sed -i '/Executed/,$!d' $text
	bf="$(awk '{for(i=1;i>0&&i<=NF;i++) if ($i=="<---BufferCapacity--->"){ print $(i+1); exit;}}' $text)"
	#echo "bf: $bf"
	sed -i.bak '/videoBitrate\|Stalling/!d' $text
        awk -F'"' '$0=$2' $text > testfile.tmp && mv testfile.tmp $text
        awk '!/Stalling/ {print $0" "'$status'" "'$bf'; '$status'="Playing"; }  /Stalling/ {'$status'="Stalling";}' $text > testfile.tmp && mv testfile.tmp $text      
        awk '{if(FNR==1){$9="Playing"" "'$bf'} print $0 }' $text > testfile.tmp && mv testfile.tmp $text
        awk '{if($8 == "Infinity"){$8=0;print $0; } else print $0; }' $text > testfile.tmp && mv testfile.tmp $text
        sed -i.bak  $text -e 's/^[^:]*:/:/' 
	sed -i.bak  $text -e 's/\://g'
	awk '{print $0, " " $8}' $text > testfile.tmp && mv testfile.tmp $text
	awk '{if(NR == 1) {shift = $2}print $0, " " (($2 - shift)/1000)}' $text > testfile.tmp && mv testfile.tmp $text
        awk '{$2=$12;  print}' $text > testfile.tmp && mv testfile.tmp $text
        awk '{$12 = "" ;  print}' $text > testfile.tmp && mv testfile.tmp $text
        awk '{tmp = $11; $11 = prev; prev = tmp; print}' $text > testfile.tmp && mv testfile.tmp $text
        awk '{if(NR == 1) print $0, " " 0;  else print $0; }'  $text > testfile.tmp && mv testfile.tmp $text
	awk '{if($8==$11) print $0, " " 0;  else {print $0, " " $8;} }'  $text > testfile.tmp && mv testfile.tmp $text
        awk '{$11= " "; print $0; }'  $text > testfile.tmp && mv testfile.tmp $text
	awk '{if(NR == 1){$11=0; print $0; } else print $0; }'  $text > testfile.tmp && mv testfile.tmp $text
        cp $text $event
        awk '{print $2" "$1" "$4" "$6" "$11" "$9" "$10}'  $event > testfile.tmp && mv testfile.tmp $event
        awk '{if($5!=0){$6="Arrival"} print $0} '  $event > testfile.tmp && mv testfile.tmp $event
        awk 'BEGIN{print "timeStamp repIndex videoBitrate bufferLength throughput event bufferCapacity"}{print $0}'  $event > testfile.tmp && mv testfile.tmp $event
        awk '{print $1","$2","$3","$4","$5","$6","$7}'  $event > testfile.tmp && mv testfile.tmp $event
       	./evalEvent.sh $event
        mv $event $m"_events"
        rm *.tmp
        rm *.bak
done
./csvCreate.sh RESULT/$opfile



echo "check RESULT and event directory for output"
