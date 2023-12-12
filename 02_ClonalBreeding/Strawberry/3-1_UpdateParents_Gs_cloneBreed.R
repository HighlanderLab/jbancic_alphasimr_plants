
#Drop Seedling parents
# old and new potential parents, all genotyped. Means that the initial pool of parents has to be genotyped as well.
# In later stages, all "nextParents" are genotyped anyway, because they derive from genotyped ST1s


parentCands <- c(parents, ST1)
parents <- selectInd(parentCands, nParents ,use="ebv")   # Estimated breeding value with useGV=F