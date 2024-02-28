# Run pedigree BLUP model internal AlphaSimR solver

# Pedigree BLUP is used to predict breeding values of Seedlings in
# order to skip HPT stages

# Prepare prediction dataset for seedlings
pedPop_tmp = rbind(pedPop,
                 data.frame(Ind   = c(Seedlings@id),
                            Sire  = c(Seedlings@father),
                            Dam   = c(Seedlings@mother),
                            Year  = year,
                            Stage = rep("Seedlings",Seedlings@nInd),
                            Pheno = NA,
                            GV = c(Seedlings@gv)))

# Construct numerator relationship matrix A
pedPop_tmp$Ind  = as.factor(pedPop_tmp$Ind)
pedPop_tmp$Dam  = as.factor(pedPop_tmp$Dam)
pedPop_tmp$Sire = as.factor(pedPop_tmp$Sire)
A = ainverse(pedPop_tmp[,1:3])

# Run model
pedPop_tmp$Year[is.na(pedPop_tmp$Year)] = 0
pedPop_tmp$Year  = as.factor(pedPop_tmp$Year)
pedPop_tmp$Stage = as.factor(pedPop_tmp$Stage)

asreml.options(trace=FALSE)
pedModel <- asreml(fixed = Pheno ~ 1 + Year,
                   random = ~ vm(Ind, A),
                   # residual = ~ dsum(~id(units) | Year),
                   residual = ~ units,
                   na.action = na.method(y='include'),
                   data = pedPop_tmp)

# Loop to ensure model converges
while (pedModel$converge != TRUE) {
  pedModel <- update.asreml(pedModel)
}

# Assign estimated breeding values to Seedling
EBV = pedModel$coef$random


rm(pedPop_tmp)

