#!/bin/bash

outfile=alles.txt
rm $outfile
touch $outfile

cols='Name RS_Number Coord Alleles MAF Distance Dprime R2 Correlated_Alleles RegulomeDB Function'
echo -ne ${cols} | sed -e 's/ /\t/g' -e 's/\t$//' >> $outfile
echo >> $outfile

i=1
amtfiles=$(find . -type f -a -name 'rs*' | wc -l)
for f in $(ls rs*); do
	j=0
	printf "Processing file (%s/%s)\r" $i $amtfiles
	while read -r line; do
		echo $line | grep ^RS_Number > /dev/null
		if [[ $? -ne 0 ]]; then
			echo -e $f $line | sed -e 's/ /\t/g' >> $outfile
		fi
		j=$((j=j+1))
	done < $f

	i=$((i=i+1))
done
echo

echo Thank you drive through: $outfile

