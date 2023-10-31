require(readr)

#Read in results
df.pheno <- read_csv("Results_LinePheno.csv")
df.GS    <- read_csv("Results_LineGS.csv")
df.GSTP  <- read_csv("Results_LineGSTP.csv")

#Plot results
png('SimResults_all.png', height = 600, width = 300)
par(mfrow=c(3,1))

#-- Genetic Gain
plot(-19:20,rowMeans(matrix(df.GSTP$meanG,ncol = max(df.pheno$rep))),type="l",
     main="Inbred genetic gain",xlab="Year",ylab="Yield",col="red")
lines(-19:20,rowMeans(matrix(df.GS$meanG,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.pheno$meanG,ncol = max(df.GS$rep))))

#-- Genetic Variance
plot(-19:20,rowMeans(matrix(df.GSTP$varG,ncol = max(df.pheno$rep))),type="l",
     main="Inbred genetic variance",xlab="Year",ylab="Variance",col="red")
lines(-19:20,rowMeans(matrix(df.GS$varG,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.pheno$varG,ncol = max(df.GS$rep))))

#-- Selection accuracy
plot(-19:20,rowMeans(matrix(df.GSTP$acc_sel,ncol = max(df.pheno$rep))),type="l",
     main="Selection accuracy",xlab="Year",ylab="Correlation",col="red",ylim = c(0,1))
lines(-19:20,rowMeans(matrix(df.GS$acc_sel,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.pheno$acc_sel,ncol = max(df.GS$rep))))

dev.off()