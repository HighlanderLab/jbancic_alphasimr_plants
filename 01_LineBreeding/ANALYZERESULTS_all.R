require(readr)

#Read in results
df.pheno <- read_csv("Results_LinePheno.csv")
df.GS    <- read_csv("Results_LineGS_const.csv")
df.GSun  <- read_csv("Results_LineGS_unconst.csv")
df.GSTP  <- read_csv("Results_LineGSTP.csv")

#Plot results
png('SimResults_all.png', height = 600, width = 300)
par(mfrow=c(3,1))

#-- Genetic Gain
plot(-19:20,rowMeans(matrix(df.GSTP$meanG,ncol = max(df.pheno$rep))),type="l",
     main="Inbred genetic gain",xlab="Year",ylab="Yield",col="red")
lines(-19:20,rowMeans(matrix(df.GS$meanG,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSun$meanG,ncol = max(df.GSun$rep))),col="lightblue")
lines(-19:20,rowMeans(matrix(df.pheno$meanG,ncol = max(df.GS$rep))))

#-- Genetic Variance
plot(-19:20,rowMeans(matrix(df.GSTP$varG,ncol = max(df.pheno$rep))),type="l",
     main="Inbred genetic variance",xlab="Year",ylab="Variance",col="red")
lines(-19:20,rowMeans(matrix(df.GS$varG,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSun$varG,ncol = max(df.GSun$rep))),col="lightblue")
lines(-19:20,rowMeans(matrix(df.pheno$varG,ncol = max(df.GS$rep))))

#-- Selection accuracy
plot(-19:20,rowMeans(matrix(df.GSTP$accSel,ncol = max(df.pheno$rep))),type="l",
     main="Selection accuracy",xlab="Year",ylab="Correlation",col="red",ylim = c(0,1))
lines(-19:20,rowMeans(matrix(df.GS$accSel,ncol = max(df.GS$rep))),col="blue")
lines(-19:20,rowMeans(matrix(df.GSun$accSel,ncol = max(df.GSun$rep))),col="lightblue")
lines(-19:20,rowMeans(matrix(df.pheno$accSel,ncol = max(df.GS$rep))))

# Add a legend
legend(x = 5, y = 1, legend=c("Pheno", "GS-const","GS-unconst","Two-Part GS"),
       col=c("black","blue", "lightblue", "red"), lty=1, cex=1)

dev.off()
