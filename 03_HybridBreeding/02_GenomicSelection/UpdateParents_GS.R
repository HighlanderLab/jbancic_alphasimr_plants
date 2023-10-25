#-----------------------------------------------------------------------
# Update parents
#-----------------------------------------------------------------------

# Replace 10 oldest inbred parents with 10 new genomically-predicted
# inbreds from DH stage

# Predict GCA of DHs
MaleDH = setEBV(MaleDH, gsModelM)
FemaleDH = setEBV(FemaleDH, gsModelF)
# Select 10 new parents based on EBVs
newMaleParents = selectInd(selectWithinFam(MaleDH, 1, use = "ebv"),
                           10, use = "ebv")
newFemaleParents = selectInd(selectWithinFam(FemaleDH, 1, use = "ebv"),
                             10, use = "ebv")
# Replace 10 oldest inbred parents with 10 new inbreds from DH stage
MaleParents   = c(MaleParents[11:nParents], newMaleParents)
FemaleParents = c(FemaleParents[11:nParents], newFemaleParents)