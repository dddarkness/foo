#!/bin/bash

for popfile in $(ls vcf/pops/*.txt);
do
	for indvrow in $(grep 'HGDP' $popfile | sed -e 's/.$//');
	do
		for pop in $(ls vcf/pops/*.txt);
			do echo vcftools --indv $indvrow --vcf total_chroms.vcf --snps EA_MTAG_SNPs.txt --keep $pop --freq --out freq-$(basename ${pop})
		done
	done
done

