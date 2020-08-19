#!/bin/bash

outfile=alles.txt
rm $outfile
touch $outfile

cols='Name RS_Number Coord Alleles MAF Distance Dprime R2 Correlated_Alleles RegulomeDB Function'
echo -ne ${cols} | sed -e 's/ /\t/g' -e 's/\t$//' >> $outfile
echo >> $outfile

tmpfall=$(mktemp)
touch $tmpfall
for f in $(ls rs*); do
	tmpf=$(mktemp)
	cat $f | grep -v ^RS_Number > $tmpf
	sed -i "s/^/$f\t/" $tmpf
	cat $tmpf >> $tmpfall
	rm $tmpf
done

cat $tmpfall >> $outfile

echo Thank you drive through: $outfile

