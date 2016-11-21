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
y="$(awk 'END{
 print $2
}' $newtext)"

AvgR=0

AvgR="$(awk ' BEGIN { sum=0;}{ sum=sum+$12;} END{ print sum/$2}' $newtext)"

VARR=0
VARR="$(awk ' BEGIN { sum=0;}{ sum=sum+ (($2-prev)*(AvgR-$4)^2); prev=$2} END{ print sum/'$y'}' $newtext)"


ChangeR=0

ChangeR="$(awk ' BEGIN { sum=0;}{ sum=sum+sqrt(($12-prev)^2); prev=$12;} END{ print sum/$2}' $newtext)"



awk '
 function ceiling(x)
{
 return (x == int(x)) ? x : int(x)+1
}

BEGIN { sum=0; 
        sumx=0;
        count=0;
        count2=0;
        eff=0;
        Bf=0;
        Be=0;
        ro=0;
        ep='$x';
        l='$y';
        ll=0;
        bRebuff=0;
        ff=60;
        flagC0unt=1;
        tIinit=0;
        tRebuff=0;
        freqRebuff=0;
        countEmpty=0;
        par1=0;
        par2=0;
        par3=0;
        emos=0;
        varR='$VARR';
        numSeg=0;
        Qlevel=0;
        QoE=0;
       if((index("'$newtext'","t1")!=0)||(index("'$newtext'","t4")!=0)||(index("'$newtext'","t5")!=0)){ff=30;}
      
       if(index("'$newtext'","t1")==0){numSeg=297;Qlevel=4100;}
       if(index("'$newtext'","t2")==0){numSeg=131;Qlevel=4077;}
       if(index("'$newtext'","t3")==0){numSeg=327;Qlevel=4103;}
       if(index("'$newtext'","t4")==0){numSeg=119;Qlevel=4140;}
       if(index("'$newtext'","t5")==0){numSeg=61;Qlevel=2116;}
       if(index("'$newtext'","t6")==0){numSeg=212;Qlevel=6169;}
       if(index("'$newtext'","t7")==0){numSeg=327;Qlevel=3413;}
        }
  { 
     if($9!=0 && flagC0unt>0)
     {
      tIinit= ($4)/($9) ;
      flagC0unt=flagC0unt-1;
      }



    sumx=sumx+$12;
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
        countEmpty=countEmpty+1;
       }

      if($6 > ff)
        {
        Bf=Bf+$11;
       }

        print $0;
    
}
END   { ro = sum/count;
        
        freqRebuff=countEmpty/l;
        
      
         QoE=(sumx/$2)-'$ChangeR'-(Qlevel*tIinit)-(Qlevel*Be)
 
        print "'$newtext'" "  ro", ro, "Full Time", Bf, "Empty Time", Be, "Inefficiency" , (eff/count2), "Total Time", $2, "x=ro/(ro+1)", ro/(ro+1),"x*TT", ((ro/(ro+1) * $2)), "quality factor", (sumx/$2), " Total Playback Bitrate ", '$p'," --->"," Tinit",tIinit, " Avg tRebuff ",Be/countEmpty, " Avg freqRebuff ", countEmpty/l, "-----",'$VARR',"StedDiV",sqrt(varR)," countEmpty ", countEmpty ," Qlevel*tIinit ",Qlevel*tIinit," Qlevel*Be ",Qlevel*Be," par3 ",par3," QoE ",QoE } ' $newtext > testfile.tmp && mv testfile.tmp $newtext
 
awk 'END{print}' $newtext >> '/home/praveen/Desktop/script/RESULT/result.log'

    # if(emos<0){emos=0;}

