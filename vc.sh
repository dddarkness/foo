#!/bin/bash

if [[ ! -d pops/ ]]; then
	echo Put population .txt files to dir pops/
	exit 1
fi

for f in $(ls *hgdp*chr*); do
	chr=$(echo $f | sed -e 's/.*chr//' -e 's/\..*//')
	for pop in $(ls pops/*.txt); do
		popname=$(echo $(basename $pop) | sed -e 's/.txt$//')
		echo processing: ./plink --file $f --extract EA_MTAG_SNPs.txt --keep-fam ${pop} --freq --make-bed --out ${popname}-Chr${chr}freq
		./plink --file $f --extract EA_MTAG_SNPs.txt --keep-fam ${pop} --freq --make-bed --out ${popname}-Chr${chr}freq
	done
done
