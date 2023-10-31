#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

#Year 6
#Release variety

#Year 5
EYT = selectInd(AYT, nEYT)
EYT = setPheno(EYT, varE = varE, reps = repEYT)

#Year 4
AYT = selectInd(PYT, nAYT)
AYT = setPheno(AYT, varE = varE, reps = repAYT)

#Year 3 - apply genomic selection ##PG I cut a year out because
#phenotyping is spared
HDRW = setEBV(DH, gsModel)
output$acc_sel[year] = cor(HDRW@gv, HDRW@ebv)
PYT = selectWithinFam(HDRW, famMax,use = "ebv")
PYT = selectInd(PYT, nPYT, use="ebv")
PYT = setPheno(PYT, varE = varE, reps = repPYT)

#Year 2
DH = makeDH(F1, nDH)

## Run population improvement
#-----------------------------
# Year 1 
ifelse((year == nBurnin+1), count <- 1, 
                            count <- count + nCyclesPI)
for(cycle in 1:nCyclesPI){
  cat("   Population improvement cycle", cycle, "/", nCyclesPI,"\n")
  if(cycle == 1){
    ##-- Cycle 1
    if (year == (nBurnin + 1)) {
      # Create F1s by random crossing parents from Burn-in
      Parents = randCross(Parents, nCrossPI)
    }
    ## 1. Select best F1s using GS
    Parents = setEBV(Parents, gsModel)
    # Report selection accuracy
    accPI$accPI[count] = cor(Parents@gv, Parents@ebv)
    # F1s to advance to  product development
    F1 = selectInd(Parents, nF1PI, use = "ebv")        
    # F1s to advance to next cycle as new parents
    Parents = selectInd(Parents, nParents, use = "ebv")   
    
    ## 2. Make parental crosses
    Parents = randCross(Parents, nCrossPI)
  } else {
    ##-- Cycle > 1
    ## 1. Select best F1s using GS
    Parents = setEBV(Parents, gsModel)
    # Report selection accuracy
    accPI$accPI[count+cycle-1] = cor(Parents@gv, Parents@ebv)
    # F1s to advance to next cycle as new parents
    Parents = selectInd(Parents, nParents, use = "ebv")  
    
    ## 2. Make parental crosses
    Parents = randCross(Parents, nCrossPI)
  }
}