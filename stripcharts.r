library(EnvStats)
ped <- read.table("chr_1_sigsnps.ped") #load the data. this example has no header. 
# what i have done here is extracted the significant snps using plink and recoded as ped
ped[ped=="TRUE"] <- "T" # some T's are returned as TRUE 
# had to check in ped file if they are actually T's. at a glance it looks ok.
ped <- ped[c(1,7:60)] # can get rid of sex and other ID's the length here is dependent on the num of significant genotypes
rownames(ped) <- ped$V1 # name the rows based on sample ID

pheno <- read.table("phenotype_CA") # load in the phenotype data, again no header. this is for C->A transversions
pheno <- as.data.frame(pheno)
rownames(pheno) <- pheno$V2 # name the rows after the ID
pheno <- pheno[2:3] # remove ID's may need to keep on column of ID
head(pheno)

i<-2 # set counter for loop
df <- as.matrix(ped[1]) # create data frame of ID and genotypes
rownames(df) <- df[]
# the ped file is structured as follows;
# rows are individuals and columns are genotypes these however are seperated by a space
while (i < length(ped)+ 1){ # loop over creating genotypes with "," seperating alleles
  temp <- do.call(paste, c(ped[c(i,i+1)], sep = ",")) # takes two col and concats
  df <- cbind(df,temp) # bind to df
  i <- i+2 # next genotype
}

df <- as.data.frame.matrix(df) # I dont know why this works
names(df)[1] <- "ID" #name cols
names(df)[2:10] <- paste0("Geno0", 1:9) # replace temp with genotype number need the zero 01:09
names(df)[11:ncol(df)] <- paste0("Geno", 10:(ncol(df) -1)) 

head(df) # check

p <- pheno[row.names(pheno) %in% row.names(df), ] # take pop out of phenotype file
testdf <- cbind(df, pheno=p$V3) # add phenotype to df

dev.new()
stripchart(pheno~Geno01, data=testdf, main="strip chart of sig snps *** population",
           ylab="Mutation rate", xlab="Genotype", vertical=T, p.value = TRUE, ci.and.test = "nonparametric",)

