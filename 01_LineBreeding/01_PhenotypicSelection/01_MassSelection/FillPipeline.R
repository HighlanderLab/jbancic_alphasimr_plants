#-----------------------------------------------------------------------
# Fill breeding pipeline
#-----------------------------------------------------------------------
#Set initial yield trials with unique individuals
for(year in 1:11){
  cat("  FillPipeline year:",year,"of 11\n")
  if(year < 3){
    #Year 1
    F1 <- randCross(Parents, nCrosses)
  }
  if(year < 2){
    #Year 2
    F1 <- setPheno(F1, varE = varE)
    selected <- selectInd(F1,nParents)
  }
  if(year < 1){
    ##Year 3
    #Release variety
  }
}
