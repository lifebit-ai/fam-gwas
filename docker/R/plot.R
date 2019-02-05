#!/usr/bin/env Rscript

library(qqman)

# read in results tables
tdt=read.table("plink.tdt", header=T) 
poo=read.table("plink.tdt.poo", header=T) 
dfam=read.table("plink.dfam", header=T)

########################################
### TDT - Transmission disequilibrium test
########################################

# make plot & colour by chromosome
png("tdt.png", width = 1000, height = 750, units = 'px', pointsize=16)
plot(tdt$BP, -log10(tdt$P), col=tdt$CHR, xlab="Base Pair Location", ylab="log10(p-value)") 

# sorts the TDT chi-squared values and plot them against their expected values, given the number of tests performed
png("QQplot.png", width = 1000, height = 750, units = 'px', pointsize=16)
plot(qchisq(ppoints(tdt$CHISQ),1), sort(tdt$CHISQ)) 
abline(a=0,b=1) 

# make Manhattan plot
png("manhattan.png", width = 1000, height = 750, units = 'px', pointsize=16)
# set columns equal to SNP, CHR, BP, P for Manhattan plot
gwas <- tdt[c(2,1,3,10)]
manhattan(gwas, annotatePval = 0.01)
# Q-Q plot of GWAS p-values
png("QQtdt.png", width = 1000, height = 750, units = 'px', pointsize=16)
qq(gwas$P)
#qq(gwas$P, xlim = c(0, 7), ylim = c(0,12), pch = 18, col = "blue4", cex = 1.5, las = 1)

########################################
### dfam - disequilibrium 
########################################
png("QQdfam.png", width = 1000, height = 750, units = 'px', pointsize=16)
qq(dfam$P)

########################################
### Poo - parent of origin
########################################
png("QQpoo.png", width = 1000, height = 750, units = 'px', pointsize=16)
qq(poo$P_POO)


dev.off()  









