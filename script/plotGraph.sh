
if [ "$*" == "" ]; then
    echo "Enter event directory"
    exit 1
else
   opfile=$1
fi

dir2=$opfile"_Graph"

#echo $dir2
mkdir $dir2 >/dev/null 2>&1

for text in $opfile/event-*.csv; do 
  echo $text	
   RPlot_script/plotBufferOccupancy.r $text
   RPlot_script/plotBitrateThroughput.r $text
done


echo "check graph in" $dir2
