# we will want to change the population name for each analysis/script
sed -e 's/asc/def/g' file.txt

# merge all chromosome association files 
awk 'FNR==1 && NR!=1 { while (/^CHR/) getline; } 1 {print}' *.assoc.linear > all.assoc.linear

# remove all duplicate snps in merged assoc file
awk '!a[$0]++' all.assoc.linear > all_rmdup.assoc.linear

# sort IGV requires file to be sorted on chr and bp. remove superfluous headers. This can be changed for adjusted file p-values
# are in col 9 
sort -k1 -k3 -g all_rmdup.assoc.linear | sed '1,21d' > pop_merged.assoc.linear
