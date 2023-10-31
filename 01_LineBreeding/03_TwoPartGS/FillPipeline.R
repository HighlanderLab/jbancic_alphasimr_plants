#-----------------------------------------------------------------------
# Fill breeding pipeline
#-----------------------------------------------------------------------
#Set initial yield trials with unique individuals
for(year in 1:7){
  cat("  FillPipeline year:",year,"of 7\n")
  if(year<7){
    #Year 1
    F1 = randCross(Parents, nCrosses)
  }
  if(year<6){
    #Year 2
    DH = makeDH(F1, nDH)
  }
  if(year<5){
    #Year 3
    HDRW = setPheno(DH, varE = varE, reps = repHDRW)
  }
  if(year<4){
    #Year 4
    PYT = selectWithinFam(HDRW, famMax)
    PYT = selectInd(PYT, nPYT)
    PYT = setPheno(PYT, varE = varE, reps = repPYT)
  }
  if(year<3){
    #Year 5
    AYT = selectInd(PYT, nAYT)
    AYT = setPheno(AYT, varE = varE, reps = repAYT)
  }
  if(year<2){
    #Year 6
    EYT = selectInd(AYT, nEYT)
    EYT = setPheno(EYT, varE = varE, reps = repEYT)
  }
  if(year<1){
    #Year 7
  }
}
