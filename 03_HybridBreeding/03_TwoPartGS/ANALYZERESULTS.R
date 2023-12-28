# install.packages(pkgs = "dplyr")
library(package = "dplyr")

# Read in results
df <- bind_rows(readRDS("HybridGSTP.rds"))
df2 <- bind_rows(readRDS("HybridGSTP_accPI.rds"))

# Plot results
png("Results.png", height = 800, width = 600)
par(mfrow=c(4,2))

# Inbred Genetic Gain
plot(-19:20,rowMeans(matrix(df$meanG_inbred,ncol = max(df$rep))),type="l",
     main="Inbred genetic gain",xlab="Year",ylab="Yield")

# Hybrid Genetic Gain
plot(-19:20,rowMeans(matrix(df$meanG_hybrid,ncol = max(df$rep))),type="l",
     main="Hybrid genetic gain",xlab="Year",ylab="Yield")

# Inbred Variance
plot(-19:20,rowMeans(matrix(df$varG_inbred,ncol = max(df$rep))),type="l",
     main="Inbred genetic variance",xlab="Year",ylab="Variance")

# Hybrid Variance
plot(-19:20,rowMeans(matrix(df$varG_hybrid,ncol = max(df$rep))),type="l",
     main="Hybrid genetic variance",xlab="Year",ylab="Correlation")

# Selection accuracy
plot(-19:20,rowMeans(matrix(df$acc_sel,ncol = max(df$rep))),type="l",
     main="Selection accuracy in Product Development",xlab="Year",ylab="Correlation")

# Selection accuracy
plot(1:40,rowMeans(matrix(df2$accPI,ncol = max(df$rep))),type="l",
     main="Selection accuracy in Population Improvement",xlab="Year",ylab="Correlation",xaxt = "n")
axis(1, at = seq(0,40,10), labels = seq(0,20,5))
abline(v = seq(1,41,2),col="gray80",lty=2)

# Correlation
plot(-19:20,rowMeans(matrix(df$cor,ncol = max(df$rep))),type="l",
     main="Inbred vs. hybrid yield cor.",xlab="Year",ylab="Variance")
dev.off()
