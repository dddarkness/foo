#!/bin/bash

set -e

# paths:
plink='../../plink'
vcf='../../hgdp_wgs'
workdir=work-$$

#  in: vcf
# out: .ped and .map
function convert_BED_to_PED()
{
	chr=$1
        $plink --vcf $vcf/hgdp_wgs*${chr}*vcf.gz --recode --tab --out hgdp_${chr}
}

function find_unlifted_SNPs_from_PED()
{
	../liftOverPlink.py --map ../../vcf/chr21.map --out lifted --chain ../GRCh38_to_GRCh37.chain -e ../liftOver
}

function remove_bad_lifted_SNPs()
{
	../rmBadLifts.py --map lifted.map --out good_lifted.map --log bad_lifted.dat
	cut -f 2 bad_lifted.dat > to_exclude.dat
	cut -f 4 lifted.bed.unlifted | sed "/^#/d" >> to_exclude.dat
	$plink --file ../../vcf/chr21.plink --recode --out lifted --exclude to_exclude.dat
}

function make_final_output_PED()
{
	$plink --ped lifted.ped --map good_lifted.map --recode --out hgdp.chr21
}

function convert_PED_to_BED()
{
	echo
}

function main()
{
	mkdir $workdir
	cd $workdir
	
	convert_BED_to_PED chr21

	cd -
}

main $*

