#!/bin/bash

for popfile in $(ls vcf/pops/*.txt);
do
	for indvrow in $(grep 'HGDP' $popfile | sed -e 's/.$//');
	do
		for pop in $(ls vcf/pops/*.txt);
			do echo vcftools --indv $indvrow --vcf total_chroms.vcf --snps EA_MTAG_SNPs.txt --freq --out freq-${indvrow}-$(basename ${pop})
			#do echo vcftools --indv $indvrow --vcf total_chroms.vcf --snps EA_MTAG_SNPs.txt --keep $pop --freq --out freq-${indvrow}-$(basename ${pop})
		done
	done
done

