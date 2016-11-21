newtext=$text+"buff"
echo $text
echo $newtext

awk '{ print $0, " " , ($9/$4); } '  $text > $newtext
awk 'BEGIN { tmp = $6; sum = 0; T = $2; } { if(NR != 1){ if($6==tmp) {sum = sum + ($2-T);print $0 " " "-------";T=$2}  else {print $0 " " sum;  tmp = $6;  sum = 0; T = $2;} } }' $newtext > testfile.tmp && mv testfile.tmp $newtext
awk '{ { if (lines > 0  ) { print a , $11; --lines;} } {  lines = 1;  a =$0; } }' $newtext > testfile.tmp && mv testfile.tmp $newtext
awk '{ { if ($12== "-------"  ){ $12=0}}  print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $12; }' $newtext > testfile.tmp && mv testfile.tmp $newtext
awk '{ print $0 " " ($2-prev)*$4; prev=$2}' $newtext > testfile.tmp && mv testfile.tmp $newtext

p="$(awk 'BEGIN { sumR = -1; x=0; } { 
 if($1!=prev)
  {
   x=sqrt(($1-prev)^2);
   sumR =sumR+x;
  }
prev=$1}
END{
 print sumR
}' $newtext)"



x=0.45
y=12




awk '
BEGIN { sum=0; 
        sumx=0;
        count=0;
        count2=0;
        eff=0;
        Bf=0;
        Be=0;
        ro=0;
        ep='$x';
        ff=120;
        
       if((index("'$newtext'","t1")!=0)||(index("'$newtext'","t4")!=0)||(index("'$newtext'","t5")!=0)){ff=120;}
     
        }
  { sumx=sumx+$12;
     if($10!=0)
     {
      sum=sum+$10;
      count=count+1;
      if($8>$4)
      {
         eff=eff+(($8-$4)/$8);
         count2=count2+1;
       }
        }

      if($6 < ep)
        {
        Be=Be+$10;
       }

      if($6 > ff)
        {
        Bf=Bf+$11;
       }

        print $0;
    
}
END   { ro = sum/count;
        print "'$newtext'" "  ro", ro, "Full Time", Bf, "Empty Time", Be, "Inefficiency" , (eff/count2), "Total Time", $2, "x=ro/(ro+1)", ro/(ro+1),"x*TT", ((ro/(ro+1) * $2)), "quality factor", (sumx/$2), " Total Playback Bitrate ", '$p'}' $newtext > testfile.tmp && mv testfile.tmp $newtext

awk 'END{print}' $newtext >> '/home/praveen/Desktop/script/RESULT/result.log'



