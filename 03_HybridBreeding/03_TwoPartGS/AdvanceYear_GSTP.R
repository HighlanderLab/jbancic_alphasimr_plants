# Advance year

cat("  Advancing year \n")
# Advance breeding program by 1 year
# Works backwards through pipeline to avoid copying data

cat("   Product development \n")

# Stage 7
# Release hybrid


# Stage 6
MaleHybridYT5 = selectInd(MaleHybridYT4, nYT5)
FemaleHybridYT5 = selectInd(FemaleHybridYT4, nYT5)

MaleHybridYT5 = setPheno(MaleHybridYT5, reps = repYT5, p = p)
FemaleHybridYT5 = setPheno(FemaleHybridYT5, reps = repYT5, p = p)

MaleInbredYT5 =
  MaleInbredYT4[MaleInbredYT4@id%in%MaleHybridYT5@mother]
FemaleInbredYT5 =
  FemaleInbredYT4[FemaleInbredYT4@id%in%FemaleHybridYT5@mother]


# Stage 5
MaleHybridYT4 = selectInd(MaleHybridYT3, nYT4)
FemaleHybridYT4 = selectInd(FemaleHybridYT3, nYT4)

MaleHybridYT4 = setPheno(MaleHybridYT4, reps = repYT4, p = p)
FemaleHybridYT4 = setPheno(FemaleHybridYT4, reps = repYT4, p = p)

MaleInbredYT4 =
  MaleInbredYT3[MaleInbredYT3@id%in%MaleHybridYT4@mother]
FemaleInbredYT4 =
  FemaleInbredYT3[FemaleInbredYT3@id%in%FemaleHybridYT4@mother]


# Stage 4
MaleInbredYT3 = selectInd(MaleYT2, nInbred3)
FemaleInbredYT3 = selectInd(FemaleYT2, nInbred3)

MaleHybridYT3 = hybridCross(MaleInbredYT3, FemaleElite)
FemaleHybridYT3 = hybridCross(FemaleInbredYT3, MaleElite)

MaleHybridYT3 = setPheno(MaleHybridYT3, reps = repYT3, p = p)
FemaleHybridYT3 = setPheno(FemaleHybridYT3, reps = repYT3, p = p)


# Stage 3 
MaleYT2 = selectInd(MaleYT1, nInbred2)
FemaleYT2 = selectInd(FemaleYT1, nInbred2)

# Grow testcross trials
MaleYT2 = setPhenoGCA(MaleYT2, FemaleTester2, reps = repYT2, inbred = T, p = p)
FemaleYT2 = setPhenoGCA(FemaleYT2, MaleTester2, reps = repYT2, inbred = T, p = p)


# Stage 2 
MaleDH = makeDH(MaleF1, nDH)
FemaleDH = makeDH(FemaleF1, nDH)

# Apply genomic selection - predict GCA of DHs
if (exists("gsModel")) {
  MaleDH = setEBV(MaleDH, gsModel)
  FemaleDH = setEBV(FemaleDH, gsModel)
} else {
  MaleDH = setEBV(MaleDH, gsModelM)
  FemaleDH = setEBV(FemaleDH, gsModelF)
}

# Report average prediction accuracy across two pools
output$acc_sel[year]  = c((cor(MaleDH@ebv,MaleDH@gv) +
                             cor(FemaleDH@ebv,FemaleDH@gv))/2)

# Make selection on EBVs
MaleDH = selectInd(selectWithinFam(MaleDH, famMax, use = "ebv"), 
                   nInbred2, use = "ebv")
FemaleDH = selectInd(selectWithinFam(FemaleDH, famMax, use = "ebv"), 
                     nInbred2, use = "ebv")

# Grow testcross trials
MaleYT1 = setPhenoGCA(MaleDH, FemaleTester1, reps = repYT1, inbred = T, p = p)
FemaleYT1 = setPhenoGCA(FemaleDH, MaleTester1, reps = repYT1, inbred = T, p = p)


# Stage 1
# Run population improvement
if (year == nBurnin + 1) {count = 0}

for(cycle in 1:nCyclesPI){
  cat("   Population improvement cycle", cycle, "/", nCyclesPI,"\n")
  if(cycle == 1){
    
    count = count + 1
    
    if (year == (nBurnin + 1)) {
      # Create F1s by random crossing parents from Burn-in
      MaleParents = randCross(MaleParents, nCrosses)
      FemaleParents = randCross(FemaleParents, nCrosses)
    }
    # 1. Select best F1s using GS
    # Predict EBVs
    if (exists("gsModel")) {
      MaleParents = setEBV(MaleParents, gsModel)
      FemaleParents = setEBV(FemaleParents, gsModel)
    } else {
      MaleParents = setEBV(MaleParents, gsModelM)
      FemaleParents = setEBV(FemaleParents, gsModelF)
    }
    # Report average prediction accuracy across two pools
    accPI$accPI[count] = c((cor(MaleParents@ebv,MaleParents@gv) +
                              cor(FemaleParents@ebv,FemaleParents@gv))/2)
    
    # F1s to advance to  product development
    MaleF1 = selectInd(selectWithinFam(MaleParents, nInd = maxFamPI, use = "ebv"), 
                       nMaleF1PI, use = "ebv")
    FemaleF1 = selectInd(selectWithinFam(FemaleParents, nInd = maxFamPI, use = "ebv"), 
                         nFemaleF1PI, use = "ebv")
    # F1s to advance to next cycle as new parents
    MaleParents = selectInd(selectWithinFam(MaleParents, nInd = maxFamPI, use = "ebv"), 
                            nParentsPI, use = "ebv")
    FemaleParents = selectInd(selectWithinFam(FemaleParents, nInd = maxFamPI, use = "ebv"), 
                              nParentsPI, use = "ebv")

    # 2. Make parental crosses
    MaleParents = randCross(MaleParents, nCrossMalePI, nProgenyPI)
    FemaleParents = randCross(FemaleParents, nCrossFemalePI, nProgenyPI)
  
  } else {
    
    count = count + 1
    
    # 1. Select best F1s using GS
    # Predict EBVs
    if (exists("gsModel")) {
      MaleParents = setEBV(MaleParents, gsModel)
      FemaleParents = setEBV(FemaleParents, gsModel)
    } else {
      MaleParents = setEBV(MaleParents, gsModelM)
      FemaleParents = setEBV(FemaleParents, gsModelF)
    }
    # Report average prediction accuracy across two pools
    accPI$accPI[count] = c((cor(MaleParents@ebv,MaleParents@gv) +
                              cor(FemaleParents@ebv,FemaleParents@gv))/2)
    # F1s to advance to next cycle as new parents
    MaleParents = selectInd(selectWithinFam(MaleParents, nInd = maxFamPI, use = "ebv"), 
                            nParentsPI, use = "ebv")
    FemaleParents = selectInd(selectWithinFam(FemaleParents, nInd = maxFamPI, use = "ebv"), 
                              nParentsPI, use = "ebv")

    # 2. Make parental crosses
    MaleParents = randCross(MaleParents, nCrossMalePI, nProgenyPI)
    FemaleParents = randCross(FemaleParents, nCrossFemalePI, nProgenyPI)
  }
}
