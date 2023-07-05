#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
# Advance breeding program by 1 year
# Works backwards through pipeline to avoid copying data

# Year 16
ECT6 = setPheno(ECT5, varE = VarE, reps = repECT, p = P[year])

# Year 15
ECT5 = ECT4

# Year 14
ECT4 = ECT3

# Year 13
ECT3 = ECT2

# Year 12
ECT2 = ECT1

# Year 11
ECT1 = selectInd(ACT5, nInd = nClonesECT, use = "pheno")

# Year 10
ACT5 = setPheno(ACT4, varE = VarE, reps = repACT, p = P[year])

# Year 9
ACT4 = ACT3

# Year 8
ACT3 = ACT2

# Year 7
ACT2 = ACT1

# Year 6
output$accSel[year] = cor(gv(HPT3), pheno(HPT3)) # accuracy based on 2000 inds
ACT1 = selectInd(HPT3, nInd = nClonesACT, use = "pheno")

# Year 5
HPT3 = setPheno(HPT2, varE = VarE, reps = repHPT, p = P[year])

# Year 4
HPT2 = HPT1

# Year 3
HPT1 = Seedlings

# Year 2
Seedlings = setPheno(F1, varE = VarE, reps = repHPT, p = P[year])

# Year 1
# Crossing block
F1 = randCross(Parents, nCrosses = nCrosses, nProgeny = nProgeny)

# Save pedigree records and training population for GS from year 35
ACT5@fixEff <- as.integer(rep(year,nInd(ACT5)))
if(year == startRecords) {
  trainPop = ACT5
  Pedigree = data.frame(Ind   = c(ACT5@id),
                        Sire  = c(ACT5@father),
                        Dam   = c(ACT5@mother),
                        Year  = year,
                        Stage = c(rep("ACT5",ACT5@nInd)),
                        Pheno = c(ACT5@pheno))
} else if(year > startRecords) {
  trainPop = c(trainPop,ACT5)
  Pedigree = rbind(Pedigree,
                   data.frame(Ind   = c(ACT5@id),
                              Sire  = c(ACT5@father),
                              Dam   = c(ACT5@mother),
                              Year  = year,
                              Stage = c(rep("ACT5",ACT5@nInd)),
                              Pheno = c(ACT5@pheno)))
}