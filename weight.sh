#!/bin/bash

file="data_weight/weight.csv"

#Get data baby
name=$(awk -F ': ' '{print $2}' data_baby/data_baby.txt | head -1 | tail -1)
sex=$(awk -F ': ' '{print $2}' data_baby/data_baby.txt | head -2 | tail -1)
borndate=$(awk -F ': ' '{print $2}' data_baby/data_baby.txt | head -3 | tail -1)
formatedborndate=$(echo $borndate | awk -F ": " '{print mktime($1" 00 00 00")}')

#Checking if date is correct
borndatecheck=$(echo $borndate | awk '{printf("%s-%s-%s",$1,$2,$3)}')
if [ -z "$borndatecheck" ] || [ "$(date -d "$borndatecheck" +%Y-%m-%d 2> /dev/null)" != "$borndatecheck" ]
then
    echo "Error. Date is incorrect"
    exit
fi

#Chosing the right percentil table
if [ "$sex" = "girl" ]
then
    pfile="data_percentiles/girlspercentiles.csv"
elif [ "$sex" = "boy" ]
then
    pfile="data_percentiles/boyspercentiles.csv"
else
    echo "Error. Sex should be \"girl\" or \"boy\" "
    exit
fi

#######Temporal file with desired format#######

awk -F [/\ ] -v b=$formatedborndate '($1!="#"){printf("%d %.14g\n",(mktime($3" "$2" "$1" 00 00 00")-b)/86400.,$4)}' $file > temp0.txt

rm temp.txt 2>/dev/null
for data in $(awk '{print $1}' temp0.txt)
do
    L=$(awk -v d=$data '($1==d){print $2}' $pfile)
    M=$(awk -v d=$data '($1==d){print $3}' $pfile)
    S=$(awk -v d=$data '($1==d){print $4}' $pfile)
    weight=$(awk -v d=$data '($1==d){print $2}' temp0.txt)
    zscore=$(echo $weight $L $M $S | awk '{printf("%.1f",(($1/$3)^($2)-1)/($2*$4))}')
    percentile=$(awk -v zs=$zscore '($1==zs){print $2*100}' data_percentiles/zscore.csv)
    echo $data $weight $percentile | awk '{print $1/30.4375,$2,$3}' >> temp.txt #30.4375 is the number of days for a month (see OMS reference)
done

###############################################

#x-range of graph
topvalue=$(tail -1 temp.txt | awk '{if($1 == int($1)){ print $1 }else{ print int($1)+1}}')

#Graphing with gnuplot!
gnuplot -e "nam='$name'" -e "se='$sex'" -e "topvalu=$topvalue" -e "pf='$pfile'" plot_weight.gpt

#Remove temporal files
rm temp0.txt 2>/dev/null
rm temp.txt 2>/dev/null
rm *~ 2>/dev/null




