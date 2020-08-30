#!/bin/bash

set -e

workdir=work-$$
mkdir $workdir
cd $workdir

../liftOverPlink.py --map ../../vcf/chr21.plink.map --out lifted --chain ../GRCh38_to_GRCh37.chain -e ../liftOver
../rmBadLifts.py --map lifted.map --out good_lifted.map --log bad_lifted.dat
cut -f 2 bad_lifted.dat > to_exclude.dat
cut -f 4 lifted.bed.unlifted | sed "/^#/d" >> to_exclude.dat
#move to_exclude.dat,bad_lifted.dat,good_lifted.map,lifted.map to plink folder
../../plink --file ../../vcf/chr21.plink --recode --out lifted --exclude to_exclude.dat
../../plink --ped lifted.ped --map good_lifted.map --recode --out hgdp.chr21

cd -

