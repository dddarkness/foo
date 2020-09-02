
#!/bin/bash

# paths:
plink='../../plink'
rmBadLifts='../rmBadLifts.py'
vcf='../../hgdp_wgs'
pops=../../vcf/pops
ea_mtag_snips='../EA_MTAG_SNPs.txt'
workdir=work-$$
# workdir=work-1371

#  in: vcf
# out: .ped and .map
function vcf_to_ped_and_map()
{
	chr=$1
	bcftools view -k $vcf/hgdp_wgs*${chr}*vcf.gz -o hgdp_${chr}.vcf
        $plink --vcf $vcf/hgdp_wgs*${chr}*vcf --recode --tab --out hgdp_${chr}
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

function do_it_without_lifting()
{
	chr=$1
	chrnum=$(echo $chr | sed -e 's/chr//')
	pop=$2
	popname=$(basename $pop | sed -e 's/.txt$//')
	$plink --file merged.out --extract $ea_mtag_snips --keep-fam $pop --freq --make-bed --out ${popname}${chrnum}freq
}

function merge()
{
	ls hgdp_*.map | xargs -l | sed -e 's/.*\./&ped &/' > merge.list
	$plink --merge-list merge.list --recode --out merged.out
}


function main()
{
	set -e

	mkdir $workdir
	cd $workdir

	for c in $(ls $vcf/hgdp_wgs*${chr}*vcf.gz); do
		chrnum=$(echo $c | sed -e 's/.*chr//' -e 's/.vcf.gz//')
		chr=chr${chrnum}

		echo processing:  $chr

		vcf_to_ped_and_map $chr
		# find_unlifted_SNPs_from_PED $chr
		# remove_bad_lifted_SNPs $chr
		# make_final_output_PED $chr
	done

	merge

	for pop in $(ls $pops/*.txt); do
		do_it_without_lifting $chr $pop
	done

	cd -
}

function init()
{
	which bcftools
	if [[ $? -ne 0 ]]; then
		echo bcftools not installed. Stop.
	else
		main $*
	fi
}

init $*

