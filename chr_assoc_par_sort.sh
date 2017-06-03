#!/bin/sh
#  job name after -N
#$ -N DB_pars_sort
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
# This script can be run directly after association study

# Parse
awk 'FNR==1 && NR!=1 { while (/^CHR/) getline; }1 {print}' *.qassoc > all.qassoc
awk 'FNR==1 && NR!=1 { while (/^CHR/) getline; }1 {print}' *.qassoc.adjusted > all.qassoc.adjusted

# remove duplicates
awk '!a[$0]++'  all.qassoc > all_rmdup.qassoc
awk '!a[$0]++'  all.qassoc.adjusted > all_rmdup.qassoc.adjusted

# sort and remove bonferroni for adjusted
sort -k5 -g all_rmdup.qassoc.adjusted > GBR_sorted_autosomes.qassoc.adjusted
sort -k9 -g all_rmdup.qassoc > GBR_sorted_autosomes.qassoc

rm all_rmdup*


# select only rows that have a bonferroni of less than 0.05 and are genome wide significant(5E-8) for linear. if using --linear  in plink | grep 'ADD' will need to be added before awk.
awk '($5 + 0) < 5E-2' GBR_sorted_autosomes.qassoc.adjusted > genome_wide_sig.qassoc.adjusted
more GBR_sorted_autosomes.qassoc | awk '($9 + 0) < 5E-8' > genome_wide_sig.qassoc

# loop over and print snp ids for plink extraction
for i in {1..22};
do
	more genome_wide_sig.qassoc.adjusted | awk '$1=='${i}' {print$2}' > chr_${i}_sigsnps.txt;
done

# call next script
qsub plink_ext_sigsnps.sh
