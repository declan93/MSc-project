library("ggplot2")
library("Cairo")

# matrix of mutation rate, DNA methylation age, mutation counts and methylation level required

# equation for outputting linear model equation
equation <- function(x){
  lm_coef <- list(a = round(coef(x)[1],digits = 2), b = round(coef(x)[2],digits = 2), r2 = round(summary(x)$r.squared, digits = 2));
  lm_eq <- substitute(italic(y) ==a +b %.% italic(x)*","~~italic(R)^2~"="~r2,lm_coef)
  as.character(as.expression(lm_eq));
}

### lin model mu vs DNAm ####

fit <- lm(CEU_full$DNAmAge~CEU_full$V3)
ggplot(CEU_full, aes(x=V3,y=DNAmAge)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="mu") + ggtitle("CEU") + annotate("text", x= 0.00000010, y = 12, label = equation(fit), parse=T) 

fit <- lm(CEU_nonwrn$DNAmAGE~CEU_nonwrn$V3)
ggplot(CEU_nonwrn, aes(x=V3,y=DNAmAGE)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="mu") + ggtitle("CEU non waring") + annotate("text", x= 0.00000010, y = 12, label = equation(fit), parse=T)

fit <- lm(YRI_full$DNAmAge~YRI_full$V3)
ggplot(YRI_full, aes(x=V3,y=DNAmAge)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="mu") + ggtitle("YRI") + annotate("text", x= 0.00000015, y = 12, label = equation(fit), parse=T)

fit <- lm(YRI_nonwrn$DNAmAge~YRI_nonwrn$V3)
ggplot(YRI_nonwrn, aes(x=V3,y=DNAmAge)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="mu") + ggtitle("YRI non warning") + annotate("text", x= 0.000000150, y = 12, label = equation(fit), parse=T)

### lin model counts vs DNAm #####

fit <- lm(CEU_full$DNAmAge~CEU_full$C_A)
ggplot(CEU_full, aes(x=C_A,y=DNAmAge)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="C_A counts") + ggtitle("CEU") + annotate("text", x = 200, y = 12, label = equation(fit), parse=T) 

fit <- lm(CEU_nonwrn$DNAmAGE~CEU_nonwrn$C_A)
ggplot(CEU_nonwrn, aes(x=C_A,y=DNAmAGE)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="C_A counts") + ggtitle("CEU non waring") + annotate("text", x= 200, y = 25, label = equation(fit), parse=T)

fit <- lm(YRI_full$DNAmAge~YRI_full$C_A)
ggplot(YRI_full, aes(x=C_A,y=DNAmAge)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="C_A counts") + ggtitle("YRI") + annotate("text", x= 200, y = 25, label = equation(fit), parse=T)

fit <- lm(YRI_nonwrn$DNAmAge~YRI_nonwrn$C_A)
ggplot(YRI_nonwrn, aes(x=C_A,y=DNAmAge)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="C_A counts") + ggtitle("YRI non warning") + annotate("text", x=200, y = 25, label = equation(fit), parse=T)

### lin model methcounts vs mu ####

fit <- lm(CEU_full$V3~CEU_full$methcounts)
ggplot(CEU_full, aes(x=methcounts,y=V3)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="Methylation counts", y= "Somatic mutation rate") + ggtitle("CEU") + annotate("text", x= 0.3, y = .0000003, label = equation(fit), parse=T) 

fit <- lm(CEU_nonwrn$V3~CEU_nonwrn$methcounts)
ggplot(CEU_nonwrn, aes(x=methcounts,y=V3)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="Methylation counts", y= "Somatic mutation rate") + ggtitle("CEU non waring") + annotate("text", x= 0.305, y = .00000025, label = equation(fit), parse=T)

fit <- lm(YRI_full$V3~YRI_full$methcounts)
ggplot(YRI_full, aes(x=methcounts,y=V3)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="Methylation counts", y= "Somatic mutation rate") + ggtitle("YRI") + annotate("text", x= 0.3, y = .0000001, label = equation(fit), parse=T)

fit <- lm(YRI_nonwrn$V3~YRI_nonwrn$methcounts)
ggplot(YRI_nonwrn, aes(x=methcounts,y=V3)) + geom_point(shape=18, color="blue") + geom_smooth(method=lm, color="darkred", fill="blue") + labs(x ="Methylation counts", y= "Somatic mutation rate") + ggtitle("YRI non warning") + annotate("text", x= 0.315, y = .00000037, label = equation(fit), parse=T)

### Correlation plots ###

library(GGally)
CEU_full_trim <- CEU_full[,2:5]
colnames(CEU_full_trim)[1] <- "Somatic_Mutation"
ggpairs(CEU_full_trim)

CEU_nw_trim <- CEU_nonwrn[,2:5]
colnames(CEU_nw_trim)[1] <- "Somatic_Mutation"
ggpairs(CEU_nw_trim)

YRI_full_trim <- YRI_full[,3:6]
colnames(YRI_full_trim)[1] <- "Somatic_Mutation"
ggpairs(YRI_full_trim)

YRI_nw_trim <- YRI_nonwrn[,3:6]
colnames(YRI_nw_trim)[1] <- "Somatic_Mutation"
ggpairs(YRI_nw_trim)
