library(ggplot2)
## github func
gg_qqplot <- function(df, ci = 0.95) {
  N  <- length(df)
  df <- data.frame(
    observed = -log10(sort(df)),
    expected = -log10(1:N / N),
    clower   = -log10(qbeta(ci,     1:N, N - 1:N + 1)),
    cupper   = -log10(qbeta(1 - ci, 1:N, N - 1:N + 1))
  )
  log10Pe <- expression(paste("Expected -log"[10], plain(P)))
  log10Po <- expression(paste("Observed -log"[10], plain(P)))
  ggplot(df) +
    geom_point(aes(expected, observed), shape = 1, size = 3) +
    geom_abline(intercept = 0, slope = 1, alpha = 0.5) +
    geom_line(aes(expected, cupper), linetype = 2) +
    geom_line(aes(expected, clower), linetype = 2, color = 'red') +
    xlab(log10Pe) +
    ylab(log10Po)
}

for (i in c("KHV","GBR","CHB","CLM","CDX","MXL","CHS","GIH","JPT","PUR","ESN","FIN","ACB","ASW","YRI","ITU","PJL","TSI","PEL","LWK","MSL","STU","GWD","IBS","CEU","BEB")){
  df <- read.table(paste(i,"_add.assoc.linear", sep=""),h=T) # impotant to only take additive model p values
  df <- df$P
  gg_qqplot(df,ci =0.95)
  #print(i)
}
