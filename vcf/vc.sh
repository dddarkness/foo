#!/bin/bash

if [[ ! -d pops/ ]]; then
	echo Put population .txt files to dir pops/
	exit 1
fi

for f in $(ls *hgdp*chr*vcf.gz); do
	chr=$(echo $f | sed -e 's/.*chr//' -e 's/\..*//')
	for pop in $(ls pops/*.txt); do
		popname=$(echo $(basename $pop) | sed -e 's/.txt$//')
		echo processing: vcftools --gzvcf $f --keep ${pop} --freq --out ${popname}-Chr${chr}freq
		vcftools --gzvcf $f --keep ${pop} --freq --out ${popname}-Chr${chr}freq
	done
done
