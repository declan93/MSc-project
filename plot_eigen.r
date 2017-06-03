# if chromosomes have the same outliars should be ok to exclude 
# 4 random chromosomes chosen
evec_chr1 <- read.table("CEU_1_pca.eigenvec", header = T)
evec_chr1$FID -> names_1
plot(evec_chr1$PC1, evec_chr1$PC2)
text(evec_chr1$PC1,evec_chr1$PC2, labels=names_1, pos = 3)

evec_chr22 <- read.table("CEU_22_pca.eigenvec", header = T)
evec_chr22$FID -> names_22
plot(evec_chr22$PC1, evec_chr22$PC2)
text(evec_chr22$PC1,evec_chr22$PC2, labels=names_22, pos = 3)

evec_chr10 <- read.table("CEU_10_pca.eigenvec", header = T)
evec_chr10$FID -> names_10
plot(evec_chr10$PC1, evec_chr10$PC2)
text(evec_chr10$PC1,evec_chr10$PC2, labels=names_10, pos = 3)

evec_chr2 <- read.table("CEU_2_pca.eigenvec", header = T)
evec_chr2$FID -> names_2
plot(evec_chr2$PC1, evec_chr2$PC2)
text(evec_chr2$PC1,evec_chr2$PC2, labels=names_2, pos = 3)
