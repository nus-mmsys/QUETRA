newtext=$event

x=0.5
AvgR=0

AvgR="$(awk -F "," ' BEGIN { sum=0;prev=0;}{if(FNR==2){prev=$1} if(FNR>1){sum=sum+($1-prev)*$3; prev=$1;}} END{ print sum/$1}'  $newtext)"


ChangeR=0

ChangeR="$(awk -F "," ' BEGIN { sum=0;}{if(FNR==2){prev=$2}if(FNR>1){ sum=sum+sqrt(($2-prev)^2); prev=$2;}} END{ print sum}' $newtext)"

pT="$(awk -F "," ' BEGIN { flag=0;}{ if(FNR!=1 && flag==0 && $4>0.5){flag=1;print $1;} } ' $newtext)"
bf=0

bf="$(awk -F "," ' { if(FNR==4){print $7;} } ' $newtext)"



awk -F "," '
 function ceiling(x)
{
 return (x == int(x)) ? x : int(x)+1
}

BEGIN { 
       
        countIneff=0;
        eff=0;
        Bf='$bf';
        Be=0;
        ep='$x';
        startStall='$pT';
        bRebuff=0;
        Overflow=0;
        OverflowCount=0;
        avgStall=0;
        freqRebuff=0;
        countEmpty=0;
         
        }
{
  if(FNR!=1){ 
        
    if($6=="Arrival" && $5>$3)
     {
      
         eff=eff+ (($5-$3)/$5);
         countIneff=countIneff+1;
     }
    
    if($6=="Stalling")
     {
      
         countEmpty=countEmpty+1;
     }
     
    if(prevBuff < ep && $1>startStall)
      {
         Be=Be+($1-prevTime);
      }

    if(prevBuff > Bf)
      {
         Overflow=Overflow+($1-prevTime);
         if($4 < Bf)
           {
             OverflowCount=OverflowCount+1
           }
       }
     prevTime=$1;
     prevBuff=$4;
   }
 
}

END   {            
      
         if(Be<0.5){Be=0;}
         if(countEmpty<1||Be==0){freqRebuff=0;countEmpty=0;Be=0;}else{avgStall=Be/countEmpty;}
      
        print "'$newtext'" , "startStall Time", startStall, "Calculate_STall Time", Be, "Inefficiency" , (eff/countIneff), "Total Time", $1, "Average bitrate", "'$AvgR'", "quality change", '$ChangeR', "Number_of_stalls", countEmpty, "Avg_Stall_Duration", avgStall, "Overflow_Duration", Overflow, "Num_of_Overflow" ,OverflowCount, "Bf", Bf } ' $newtext >> RESULT/$opfile


 
#awk 'END{print}' $newtext >> RESULT/$opfile

    # if(emos<0){emos=0;}    if($6 != prevBuff)

