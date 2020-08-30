plink --bfile hgdp_chr22 --recode --tab --out hgdp_chr22
python liftOverPlink.py --map hgdp_chr22.map --out lifted --chain GRCh38_to_GRCh37.chain -e /path/liftOver
python rmBadLifts.py --map lifted.map --out good_lifted.map --log bad_lifted.dat
cut -f 2 bad_lifted.dat > to_exclude.dat
cut -f 4 lifted.bed.unlifted | sed "/^#/d" >> to_exclude.dat
plink --file hgdp_chr22 --recode --out lifted --exclude bad_lifted.datstep4
python liftOverPlink.py -m lifted.map -p lifted.ped -o final_chr22 -c GRCh38_to_GRCh37.chain -d to_exclude.dat -e /path/liftOver
plink --file final_chr22 --make-bed --out final_chr22           #optional


