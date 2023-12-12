#-----------------------------------------------------------------------
# Fill breeding pipeline
#-----------------------------------------------------------------------
#Set initial yield trials with unique individuals
for(stage in 1:2){
  cat("  FillPipeline stage:",stage,"of 2\n")
  if(stage < 3){
    #Stage 1
    F1 <- randCross(Parents, nCrosses)
  }
  if(stage < 2){
    #Stage 2
    F1 <- setPheno(F1, varE = varE)
    selected <- selectInd(F1,nParents)
  }
  if(stage < 1){
    ##Stage 3
    #Release variety
  }
}
