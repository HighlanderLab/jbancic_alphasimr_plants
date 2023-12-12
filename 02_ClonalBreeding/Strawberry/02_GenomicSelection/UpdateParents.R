#-----------------------------------------------------------------------
# Update Parents
#-----------------------------------------------------------------------
# Every year 30 of 60 Parents are replaced by individuals from 
# ST3, ST4, and ST5. All remaining are replaced by best performing ST2s.

# Remove 30 worst-performing Parents
Parents = selectInd(pop = Parents, nInd = (nParents-30))

# Take new unique candidates from ST3, ST4, and ST5
newParents = c(ST3,ST4,ST5)
Parents = c(Parents, newParents[!(newParents@id%in%Parents@id)])

# Fill remaining parentalslots with ST2 lines
newParents = selectInd(pop = ST2, nInd = (nParents-length(Parents@id)))

if(length(newParents) > 0){
  Parents = c(Parents, newParents)
}

rm(newParents)
