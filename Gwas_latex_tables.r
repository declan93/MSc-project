#!/usr/bin/env Rscript
# loop over population folders and output latex table
library(xtable)
for (i in c("KHV","GBR","CHB","CLM","CDX","MXL","CHS","GIH","JPT","PUR","ESN","FIN","ACB","ASW","YRI","ITU","PJL","TSI","PEL","LWK","MSL","STU","GWD","IBS","CEU","BEB")){
        setwd(paste("/data4/Declan/MSc_project/analysis_all_covar/",i, sep=""))
	x <- read.table(paste(i, "_all.assoc.linear.adjusted", sep=""), h=T)
	print(xtable(x[1:10,], type = "latex", digits=c(0,0,0,-2,-2,-2,-2,-2,-2,-2,-2)), file = paste(i,"_vcfassoc.tex", sep =""))
	#rm(list=ls()) can be used to delete stored variable
}
	
