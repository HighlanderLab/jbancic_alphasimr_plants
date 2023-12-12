#-----------------------------------------------------------------------
# Fill breeding pipeline 
#-----------------------------------------------------------------------
#Set initial yield trials with unique individuals

# Breeding program
for(year in 1:6){
  cat("FillPipeline year:",year,"of 6\n")
  if(year<7){
    #Year 1
    Seedlings = randCross(Parents, nCrosses, nProgeny)
    Seedlings = setPheno(Seedlings, varE = seedVarE, reps = 1)
  }
  if(year<6){
    #Year 2
    ST1 = selectInd(selectWithinFam(Seedlings, maxFam), nS1)
    ST1 = setPheno(ST1, varE = stageVarE, rep = 1)
  }
  if(year<5){
    #Year 3
    ST2 = selectInd(ST1, nS2)
    ST2 = setPheno(ST2, varE = stageVarE, reps = repS2)
  }
  if(year<4){
    #Year 4
    ST3 = selectInd(ST2, nS3)
    ST3 = setPheno(ST3, varE = stageVarE, reps = repS3)
  }
  if(year<3){
    #Year 5
    ST4 = selectInd(ST3, nS4)
    ST4 = setPheno(ST4, varE = stageVarE, reps = repS45)
  }
  if(year<2){
    #Year 6
    ST5 = setPheno(ST4, varE = stageVarE, reps = repS45)
    ST5@pheno = (ST4@pheno+ST5@pheno)/2
  }
  if(year<1){
    #Year 7
  }
}
