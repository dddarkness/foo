#!/bin/bash

# paths:
plink='../../plink'
rmBadLifts='../rmBadLifts.py'
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
	chr=$1
	../liftOverPlink.py --map hgdp_${chr}.map --out lifted --chain ../GRCh38_to_GRCh37.chain -e ../liftOver
}

function remove_bad_lifted_SNPs()
{
	chr=$1
	$rmBadLifts --map lifted.map --out good_lifted.map --log bad_lifted.dat
	cut -f 2 bad_lifted.dat > to_exclude.dat
	cut -f 4 lifted.bed.unlifted | sed "/^#/d" >> to_exclude.dat
	$plink --file hgdp_${chr} --recode --out lifted --exclude to_exclude.dat
}

function make_final_output_PED()
{
	$plink --ped lifted.ped --map good_lifted.map --recode --out hgdp.chr21
}

function convert_PED_to_BED()
{
	echo TODO
}

function main()
{
	set -e

	chr=chr${1}
	mkdir $workdir
	cd $workdir
	
	convert_BED_to_PED $chr
	find_unlifted_SNPs_from_PED $chr
	remove_bad_lifted_SNPs $chr
	make_final_output_PED $chr

	cd -
}

function init()
{
	which bcftools
	if [[ $? -ne 0 ]]; then
		echo bcftools not installed. Stop.
	else
		if [[ $# -eq 1 ]]; then
			main $*
		else
			echo usage: $(basename $0) '<chr number>'
		fi
	fi
}

init $*
