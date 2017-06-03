# Taking the bonferroni corrected snps
vep -i sigsnps.txt -o pop_adj --cache --merge --nearest symbol --force_overwrite

# list of genes nearest the snps is a nice thing to have for gene set enrichment. 
more pop_adj | awk -F ";" '{print$5}' | cut -d'=' -f2 | sed '/^\s*$/d' | sort | uniq > vep_impact_g.txt
