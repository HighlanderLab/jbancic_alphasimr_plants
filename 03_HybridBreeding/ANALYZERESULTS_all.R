require(readr)

#Read in results
df.pheno <- read_csv("Results_HybridPheno.csv")
df.GS   <- read_csv("Results_HybridGS.csv")
df.GSTP <- read_csv("Results_HybridGSTP.csv")

#Plot results
png('SimResults_all.png')
par(mfrow=c(3,2))

#-- Inbred Genetic Gain
plot(-19:20,rowMeans(matrix(df.pheno$meanG_inbred,ncol = max(df.pheno$rep))),type="l",
     main="Inbred genetic gain",xlab="Year",ylab="Yield")
lines(-19:20,rowMeans(matrix(df.GS$meanG_inbred,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSTP$meanG_inbred,ncol = max(df.GS$rep))),col="red")

#-- Hybrid Genetic Gain
plot(-19:20,rowMeans(matrix(df.pheno$meanG_hybrid,ncol = max(df.pheno$rep))),type="l",
     main="Hybrid genetic gain",xlab="Year",ylab="Yield")
lines(-19:20,rowMeans(matrix(df.GS$meanG_hybrid,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSTP$meanG_hybrid,ncol = max(df.GS$rep))),col="red")

#-- Inbred Variance
plot(-19:20,rowMeans(matrix(df.pheno$varG_inbred,ncol = max(df.pheno$rep))),type="l",
     main="Inbred genetic variance",xlab="Year",ylab="Variance")
lines(-19:20,rowMeans(matrix(df.GS$varG_inbred,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSTP$varG_inbred,ncol = max(df.GS$rep))),col="red")

#-- Hybrid Variance
plot(-19:20,rowMeans(matrix(df.pheno$varG_hybrid,ncol = max(df.pheno$rep))),type="l",
     main="Hybrid genetic variance",xlab="Year",ylab="Correlation")
lines(-19:20,rowMeans(matrix(df.GS$varG_hybrid,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSTP$varG_hybrid,ncol = max(df.GS$rep))),col="red")

#-- Selection accuracy
plot(-19:20,rowMeans(matrix(df.pheno$acc_sel,ncol = max(df.pheno$rep))),type="l",
     main="Selection accuracy",xlab="Year",ylab="Correlation")
lines(-19:20,rowMeans(matrix(df.GS$acc_sel,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSTP$acc_sel,ncol = max(df.GS$rep))),col="red")

#-- Correlation
plot(-19:20,rowMeans(matrix(df.pheno$cor,ncol = max(df.pheno$rep))),type="l",
     main="Inbred vs. hybrid yield cor.",xlab="Year",ylab="Variance")
lines(-19:20,rowMeans(matrix(df.GS$cor,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSTP$cor,ncol = max(df.GS$rep))),col="red")

dev.off()