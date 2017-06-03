# SGE array for individual chromosome analysis
#!/bin/sh

# Your job name
#$ -N Db_assoc_ACB
# The job should be placed into the queue 'all.q'
#$ -q all.q
# Tell the SGE that this is an array job, with "tasks" to be numbered 1 to 22. will work instead of a for loop if files are numbered.
#$ -t 1-22
# Running in the current directory
#$ -cwd
# Export some necessary environment variables
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTLONPATH
#$ -S /bin/bash

# 1st command to extract pop from vcf file and make into binary plink formatted files.
plink --vcf /data4/cathal/Mutation/Phase3/ALL.chr${SGE_TASK_ID}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf --biallelic-only strict --make-bed --keep ACB_pop.txt --out ACB_VCF_chr_${SGE_TASK_ID}

# going to find duplicate snp ids and try and remove them
plink --bfile ACB_VCF_chr_${SGE_TASK_ID} --list-duplicate-vars suppress-first --out ACB_chr_${SGE_TASK_ID}_snps.txt

plink --bfile ACB_VCF_chr_${SGE_TASK_ID} --exclude ACB_chr_${SGE_TASK_ID}_snps.txt.dupvar --make-bed --out ACB_VCF_chr_${SGE_TASK_ID}
rm ACB_VCF_chr_${SGE_TASK_ID}*~

plink --bfile ACB_VCF_chr_${SGE_TASK_ID} --mind 0.1 --geno 0.1 --maf 0.01 --hwe 0.005 --make-bed --out ACB_mgm_chr_${SGE_TASK_ID}

plink --bfile ACB_mgm_chr_${SGE_TASK_ID} --recode --out ${SGE_TASK_ID}_recode

# search map file for any snp/indel overlap and add to dup_file These are snp/indels at the same position
awk '{print$2}' ${SGE_TASK_ID}_recode.map | sort | uniq -d > dup${SGE_TASK_ID}.txt

# Remove these duplicates
plink --bfile ACB_mgm_chr_${SGE_TASK_ID} --exclude dup${SGE_TASK_ID}.txt --make-bed --out ACB_rec_ex_chr_${SGE_TASK_ID}
# recode to ped/map and extract a list of duplicated snps/indels

# loop over and prune 50 kb window 5 0.2 can change. was 100 25 0.2, with maf 0.05 geno 0.1 and mind 1 17000 variants made it through # was 1103k variants before any cleaning. may need to change
plink --bfile ACB_rec_ex_chr_${SGE_TASK_ID} --indep-pairwise 50 5 0.2 --out ACB_mgm_chr_${SGE_TASK_ID}_thinned

#remove the high ld variants from previous step
plink --bfile ACB_rec_ex_chr_${SGE_TASK_ID} --extract ACB_mgm_chr_${SGE_TASK_ID}_thinned.prune.in --make-bed --out ACB_${SGE_TASK_ID}_cleaned_pruned

# PCA
plink --bfile ACB_${SGE_TASK_ID}_cleaned_pruned --pca header --make-bed --out ACB_${SGE_TASK_ID}_pca

# PC1 and PC2 as covariates to controll for population. fit linear model to data add confidence intervals
plink --bfile ACB_${SGE_TASK_ID}_pca --assoc --allow-no-sex --ci 0.95 --covar ACB_${SGE_TASK_ID}_pca.eigenvec --covar-name PC1, PC2 --pheno /data4/cathal/Soma2/phenotype_CA --adjust --out ACB_${SGE_TASK_ID}

# clump variants on loci for DEPICT
plink --bfile ACB_${SGE_TASK_ID}_pca --clump ACB_${SGE_TASK_ID}.qassoc --clump-p1 5e-8 --clump-kb 500 --clump-r2 0.05 --out ACB_${SGE_TASK_ID}_depict

# need to sleep until chr 2 finishes for merging ped files
while [ ! -f ./ACB_2_pca.fam && ./ACB_1_pca.fam ]; do sleep 10; done

# merge all bed bim and fam files. run association then compare output
plink --merge-list ACB_merged.txt --out all_chr
# PCA
plink --bfile all_chr --pca header --make-bed --out ACB_all_pca
# assoc
plink --bfile ACB_all_pca --assoc --allow-no-sex --ci 0.95 --covar ACB_all_pca.eigenvec --covar-name PC1, PC2 --pheno /data4/cathal/Soma2/phenotype_CA --adjust --out ACB_all
