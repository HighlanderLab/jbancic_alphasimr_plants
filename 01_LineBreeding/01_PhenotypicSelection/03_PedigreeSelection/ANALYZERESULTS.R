# install.packages(pkgs = "dplyr")
library(package = "dplyr")

# Simulation variables
scenarioName = "LinePheno_pedigree"
nCycles = 40

# Read in results
df <- bind_rows(readRDS(paste0(scenarioName,".rds")))

# Plot results
png("Results.png", height = 600, width = 300)
par(mfrow=c(3,1))

# Genetic Gain
plot(1:nCycles,rowMeans(matrix(df$meanG,ncol = max(df$rep))),type="l",
     main="Genetic gain",xlab="Year",ylab="Yield")

# Genetic Variance
plot(1:nCycles,rowMeans(matrix(df$varG,ncol = max(df$rep))),type="l",
     main="Genetic variance",xlab="Year",ylab="Variance")

# Selection accuracy
plot(1:nCycles,rowMeans(matrix(df$accSel,ncol = max(df$rep))),type="l",
     main="Selection accuracy",xlab="Year",ylab="Accuracy")
dev.off()