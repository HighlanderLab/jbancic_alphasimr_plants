#-----------------------------------------------------------------------
# Update Parents
#-----------------------------------------------------------------------

# Use genomic selection to predict ebvs of ST1 individuals and select
# new parents
Parents = setEBV(c(Parents, ST1), gsmodel, value = "bv")
Parents = selectInd(Parents, nParents, use = "ebv")