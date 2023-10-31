#-----------------------------------------------------------------------
# Fill breeding pipeline
#-----------------------------------------------------------------------
#Set initial yield trials with unique individuals
for(year in 1:11){
  cat("  FillPipeline year:",year,"of 11\n")
  if(year < 11){
    #Year 1
    F1 = randCross(Parents, nCrosses)
  }
  if(year < 10){
    #Year 2
    S0 = self(F1, nSelf)
  }
  if(year < 9){
    ##Year 3
    S1 = self(S0, nSelf)
  }
  if(year < 8){
    ##Year 4
    S2 = self(S1) ##PG How many seeds per selfing. I have stopped
    ##keeping more than 1 after S1, since homozygosity will already
    ##have declined
  }
  if(year < 7){
    ##Year 5
    S3 = self(S2)
  }
  if(year < 6){
    ##Year 6
    S4 = self(S3)
  }
  if(year < 5){
    ##Year 7
    HDRW = setPheno(S4, varE = varE, reps = repHDRW)
  }
  if(year < 4){
    ##Year 8
    PYT = selectWithinFam(HDRW, famMax)
    PYT = selectInd(PYT, nPYT)
    PYT = setPheno(PYT, varE = varE, reps = repPYT)
  }
  if(year < 3){
    #Year 9
    AYT = selectInd(PYT, nAYT)
    AYT = setPheno(AYT, varE = varE, reps = repAYT)
  }
  if(year < 2){
    #Year 10
    EYT = selectInd(AYT, nEYT)
    EYT = setPheno(EYT, varE = varE, reps = repEYT)
  }
  if(year < 1){
    #Year 11
    #Release variety
  }
}
