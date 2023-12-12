#-----------------------------------------------------------------------
# Fill breeding pipeline
#-----------------------------------------------------------------------
#Set initial yield trials with unique individuals
for(stage in 1:7){
  cat("  FillPipeline stage:",stage,"of 7\n")
  if(stage<7){
    #Stage 1
    F1 = randCross(Parents, nCrosses)
  }
  if(stage<6){
    #Stage 2
    DH = makeDH(F1, nDH)
  }
  if(stage<5){
    #Stage 3
    HDRW = setPheno(DH, varE = varE, reps = repHDRW)
  }
  if(stage<4){
    #Stage 4
    PYT = selectWithinFam(HDRW, famMax)
    PYT = selectInd(PYT, nPYT)
    PYT = setPheno(PYT, varE = varE, reps = repPYT)
  }
  if(stage<3){
    #Stage 5
    AYT = selectInd(PYT, nAYT)
    AYT = setPheno(AYT, varE = varE, reps = repAYT)
  }
  if(stage<2){
    #Stage 6
    EYT = selectInd(AYT, nEYT)
    EYT = setPheno(EYT, varE = varE, reps = repEYT)
  }
  if(stage<1){
    #Stage 7
  }
}
