
### EVERY YEAR, 30 OF 60 PARENTS ARE REPLACED BY
### 1. ALL ST3 - ST5 WHICH ARE NOT YET PART OF THE PARENTS
### 2. ALL REMAINING SLOTS ARE FILLED WITH THE BEST PERFORMING S2s 
###   --> wether they are better than the 30 parents discarded before or not
###   --> reflects the fact that parents are in general not longer used in a strawberry breeding program than at most 5 yrs (due to maintenance of clone parents)

#Drop Seedling parents
parents = selectInd(pop=parents, nInd=(nParents-newParents))  # selects the best-performing current parents


#Add all S3-S5 lines which are not already included in nextParents from the years before
parentCands = c(ST3,ST4,ST5)
newInds =!(parentCands@id%in%parents@id)
parents = c(parents, parentCands[newInds])
rm(parentCands)
rm(newInds)


# Fill all emtpy parental slots up to total number of parents with the best performing individuals from stage 2
st2Parents = selectInd(pop=ST2, nInd=(nParents-length(parents@id)))

if(length(st2Parents) >0){
parents = c(parents, st2Parents)
}

rm(st2Parents)
