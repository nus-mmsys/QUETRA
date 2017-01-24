newtext="buff-"$text
#echo $text
#echo $newtext
#echo $STALL
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



x=0.5
y="$(awk 'END{
 print $2
}' $newtext)"

AvgR=0

AvgR="$(awk ' BEGIN { sum=0;}{ sum=sum+$12;} END{ print sum/$2}' $newtext)"

VARR=0
VARR="$(awk ' BEGIN { sum=0;}{ sum=sum+ (($2-prev)*(AvgR-$4)^2); prev=$2} END{ print sum/'$y'}' $newtext)"


ChangeR=0

ChangeR="$(awk ' BEGIN { sum=0;}{ sum=sum+sqrt(($4-prev)^2); prev=$4;} END{ print sum}' $newtext)"

pT="$(awk ' BEGIN { flag=0;}{ if(flag==0 && $6>0.5){flag=1;print $2;} } ' $newtext)"


#Update Bf i.e buffer full or MAx buffer capacity for log in following script:

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
        startStall='$pT';
        ll=0;
        bRebuff=0;
        ff=60;
        flagC0unt=2;
        flagC0unt2=1;
        Overflow=0;
        OverflowCount=0;
        tIinit=0;
        tFinal=0;
        tRebuff=0;
        avgStall=0;
        freqRebuff=0;
        countEmpty='$STALL';
        par1=0;
        par2=0;
        par3=0;
        emos=0;
        varR='$VARR';
        numSeg=0;
        Qlevel=0;
        QoE=0;
        if(index("'$newtext'","t1")!=0) {ff=594;numSeg=2;Qlevel=4100;  Bf=240;}
        if(index("'$newtext'","t2")!=0) {ff=654;numSeg=5;Qlevel=4077;  Bf=240;}
	if(index("'$newtext'","t3")!=0) {ff=654;numSeg=2;Qlevel=4103;  Bf=240;}
	if(index("'$newtext'","t4")!=0) {ff=594;numSeg=5;Qlevel=4140; Bf=240;}
	if(index("'$newtext'","t5")!=0) {ff=244;numSeg=4;Qlevel=2116; Bf=240;}
	if(index("'$newtext'","t6")!=0) {ff=634;numSeg=3;Qlevel=6169; Bf=240;}
	if(index("'$newtext'","t7")!=0) {ff=653;numSeg=1.933;Qlevel=3413; Bf=240;}
          
      
       if(index("'$newtext'","t1")==0){}
       if(index("'$newtext'","t2")==0){}
       if(index("'$newtext'","t3")==0){}
       if(index("'$newtext'","t4")==0){}
       if(index("'$newtext'","t5")==0){}
       if(index("'$newtext'","t6")==0){}
       if(index("'$newtext'","t7")==0){}
        }
  { 
     if($9!=0 && flagC0unt>0)
     {
      tIinit=$2 ;
      flagC0unt=flagC0unt-1;
      }


     if($6!=0 && flagC0unt2>0)
     {
      tFinal=$2 ;
      flagC0unt2=flagC0unt2-1;
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

      if(prevBuff < ep && $2>startStall)
        {
        Be=Be+($2-prevTime);
        }

      if(prevBuff > Bf)
        {
         Overflow=Overflow+($2-prevTime);
         if($6 != prevBuff)
           {
             OverflowCount=OverflowCount+1
            }
       }
     
     

        print $0;

     prevTime=$2;
     prevBuff=$6;
}
END   {            
      
         if(Be<0.5){Be=0;}
         if(countEmpty<1||Be==0){freqRebuff=0;countEmpty=0;Be=0;}else{avgStall=Be/countEmpty;}
      
        print "'$newtext'" , "startStall Time", startStall, "Calculate_STall Time", Be, "Inefficiency" , (eff/count2), "Total Time", $2, "Average bitrate", (sumx/$2), "quality change", '$p', "Number_of_stalls", countEmpty, "Avg_Stall_Duration", avgStall, "Overflow_Duration", Overflow, "Num_of_Overflow" ,OverflowCount, "Bf", Bf } ' $newtext > testfile.tmp && mv testfile.tmp $newtext
 
awk 'END{print}' $newtext >> '/home/praveen/Desktop/script/RESULT/result.log'

    # if(emos<0){emos=0;}

