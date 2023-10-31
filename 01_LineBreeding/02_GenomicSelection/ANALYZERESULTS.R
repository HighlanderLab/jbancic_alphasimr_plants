require(dplyr)

#Read in results
png("Results.png")
df <- bind_rows(readRDS("LineGS.rds"))

#Plot results
par(mfrow=c(3,1))

#-- Genetic Gain
plot(-19:20,rowMeans(matrix(df$meanG,ncol = max(df$rep))),type="l",
     main="Genetic gain",xlab="Year",ylab="Yield")

#-- Variance
plot(-19:20,rowMeans(matrix(df$varG,ncol = max(df$rep))),type="l",
     main="Genetic variance",xlab="Year",ylab="Variance")

#-- Selection accuracy
plot(-19:20,rowMeans(matrix(df$acc_sel,ncol = max(df$rep))),type="l",
     main="Selection accuracy",xlab="Year",ylab="Correlation")

dev.off()
