#Only required when working with individual chromosomes
#!/bin/sh
#  job name after -N
#$ -N DB_ext_sigsnps
# The job should be placed into the queue 'all.q'
#$ -q all.q
# Running in the current directory
#$ -cwd
#$ -m bea
#$ -M d.bennett1@nuigalway.ie
# Export some necessary environment variables
#$ -S /bin/bash
#$ -v PATH
#$ -v LD_LIBRARY_PATH
#$ -v PYTHONPATH
# This will extract the genotype data in readable for the significant snps

for k in {1..22};
do
        plink --bfile ESN_${k}_cleaned_pruned --extract chr_${k}_sigsnps.txt --recode --out chr_${k}_sigsnps;
done

# some chromosomes will have empty files. remove null files 
for j in *;
do
    if [ -s $j ];
    then
        continue
    else
        rm -rf $j;
    fi
done
