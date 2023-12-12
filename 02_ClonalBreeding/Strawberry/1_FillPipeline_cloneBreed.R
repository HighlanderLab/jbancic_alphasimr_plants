#Set initial yield trials with unique individuals
#Ignoring GxY at this time

for(year in 1:6){
  cat("FillPipeline year:",year,"of 6\n")
  if(year<7){
    #Year 1
    seedlings = randCross(parents,nCrosses, nProgeny=nFamLines)
    seedlings = setPheno(seedlings, varE=eVarSeed, reps=1)        # low h2
  }
  if(year<6){
    
    #Year 2
    seedlings = selectWithinFam(seedlings, famMaxSeed)
    
    ST1 = selectInd(seedlings, nS1)
    ST1 = setPheno(ST1, varE=eVarSt1, rep=1)
    }
  if(year<5){
    #Year 3
    ST2 = selectInd(ST1, nS2)
    ST2 = setPheno(ST2, varE=eVarSt1, reps=repS2)
  }
  if(year<4){
    #Year 4
    ST3 = selectInd(ST2, nS3)
    ST3 = setPheno(ST3, varE=eVarSt1, reps=repS3)
  }
  if(year<3){
    #Year 5
    ST4 = selectInd(ST3, nS4)
    ST4 = setPheno(ST4, varE=eVarSt1, reps=repS45)
  }
  if(year<2){
    #Year 6
    ST5 = setPheno(ST4, varE=eVarSt1, reps=repS45)
    ST5@pheno = (ST4@pheno+ST5@pheno)/2
  }
  if(year<1){
    #Year 7
  }
}
