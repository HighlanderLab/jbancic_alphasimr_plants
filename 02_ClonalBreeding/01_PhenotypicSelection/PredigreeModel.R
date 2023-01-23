# This script runs a pedigree model using ASReml

# Prepare prediction dataset for seedlings
ped_temp = rbind(ped,
                 data.frame(Ind = c(Seedlings@id),
                            Sire = c(Seedlings@father),
                            Dam = c(Seedlings@mother),
                            Year = year,
                            Stage = rep("Seedlings",Seedlings@nInd),
                            Pheno = NA))
# table(ped_temp$Year)

# Construct numerator relationship matrix A
ped_temp$Ind = as.factor(ped_temp$Ind)
ped_temp$Dam = as.factor(ped_temp$Dam)
ped_temp$Sire = as.factor(ped_temp$Sire)
A = ainverse(ped_temp[,1:3])

# Run model
ped_temp$Year[is.na(ped_temp$Year)] <- 0
ped_temp$Year = as.factor(ped_temp$Year)
ped_temp$Stage = as.factor(ped_temp$Stage)

asreml.options(trace=FALSE)
pedModel <- asreml(fixed = Pheno ~ 1 + Year, 
                   random = ~ vm(Ind, A),
                   residual = ~ dsum(~id(units) | Year), # different residual each year
                   na.action=na.method(y='include'),
                   data = ped_temp)
# Loop to ensure model converges
while (pedModel$converge != TRUE) {
  pedModel <- update.asreml(pedModel)
}
# wald(pedModel)
# summary(pedModel)$varcom
# no year                    -38841.66 0.262986
# year                       -38748.68 0.3547642
# year + stage               -38716.64 0.3558516
# year + stage + year:stage  -38665.58 0.356401
# year + year-residual       -37669.41 0.3609048

EBV = pedModel$coef$random
rm(ped_temp)

# Seedlings@ebv = as.matrix(tail(EBV, Seedlings@nInd))
# cor(gv(Seedlings), ebv(Seedlings))
# cor(gv(Seedlings), pheno(Seedlings))
