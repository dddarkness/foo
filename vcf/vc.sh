#!/bin/bash

set -e

hgdp_files='../../hgdp_wgs/hgdp*chr*vcf.gz'
popsdir='../pops/'
workdir=work-$$

mkdir $workdir
cd $workdir

if [[ ! -d ${popsdir} ]]; then
	echo Put population .txt files to dir pops/
	exit 1
fi

for f in $(ls $hgdp_files); do
	chr=$(echo $f | sed -e 's/.*chr//' -e 's/\..*//')
	echo chr $chr
	for pop in $(ls ${popsdir}/*.txt); do
		popname=$(echo $(basename $pop) | sed -e 's/.txt$//')
		echo processing: vcftools --gzvcf $f --keep ${pop} --freq --out ${popname}-Chr${chr}freq
		vcftools --gzvcf $f --keep ${pop} --freq --out ${popname}-Chr${chr}freq
	done
done

cd -
