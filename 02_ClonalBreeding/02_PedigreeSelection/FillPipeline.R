#-----------------------------------------------------------------------
# Fill breeding pipeline 
#-----------------------------------------------------------------------
#Set initial yield trials with unique individuals

# Sample year effects
P = runif(16)

# Breeding program
for(year in 1:16) {
  cat("  FillPipeline year:",year,"of 16\n")
  # Year 1 Crossing block
  F1 = randCross(Parents, nCrosses = nCrosses, nProgeny = nProgeny)
  if(year < 16){
    # Year 2 Germinate the seedlings in the nursery
    Seedlings = setPheno(F1, varE = VarE, reps = repHPT, p = P[year])
  }
  if(year < 15){
    # Year 3 Plant in the seedlings in the field as HPT and record yields
    HPT1 = Seedlings
  }
  if(year < 14){
    # Year 4 Record the HPT yields
    HPT2 = HPT1
  }
  if(year < 13){
    # Year 5 Record the HPT yields
    HPT3 = setPheno(HPT2, varE = VarE, reps = repHPT, p = P[year+3L])
  }
  if(year < 12){
    # Year 6 Select 500 superior individuals and plant as advanced clonal trials (ACT)
    ACT1 = selectInd(HPT3, nInd = nClonesACT, use = "pheno")
  }
  if(year < 11){
    # Year 7 Record ACT yields
    ACT2 = ACT1
  }
  if(year < 10){
    # Year 8 Record ACT yields
    ACT3 = ACT2
  }
  if(year < 9){
    # Year 9 Record ACT yields
    ACT4 = ACT3
  }
  if(year < 8){
    # Year 10 Record ACT yields
    ACT5 = setPheno(ACT4, varE = VarE, reps = repACT, p = P[year+8L])
  }
  if(year < 7){
    # Year 11 Select 30 superior individuals and plant as elite clonal trials (ECT)
    ECT1 = selectInd(ACT5, nInd = nClonesECT, use = "pheno")
  }
  if(year < 6){
    # Year 12 Record ECT yields
    ECT2 = ECT1
  }
  if(year < 5){
    # Year 13 Record ECT yields
    ECT3 = ECT2
  }
  if(year < 4){
    # Year 14 Record ECT yields
    ECT4 = ECT3
  }
  if(year < 3){
    # Year 15 Record ECT yields
    ECT5 = ECT4
  }
  if(year < 2){
    # Year 16 Record ECT yields
    ECT6 = setPheno(ECT5, varE = VarE, reps = repECT, p = P[year+14L])
  }
}
