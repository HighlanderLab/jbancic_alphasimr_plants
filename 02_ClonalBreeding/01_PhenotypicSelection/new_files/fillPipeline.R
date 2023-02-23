for(year in 1:16){
                                        # Year 1
                                        # Crossing block
  F1 = randCross(Parents, nCrosses=ncross, nProgeny = nProgPheno)

                                        # Year 2 Germinate the seedlings in the nursery
  if(year < 16){
    Seedlings = setPheno(F1, varE = VarE, reps = repHPT, p = P[year])

  }

                                        # Year 3 Plant in the seedlings in the field as HPT and record yields
  if(year < 15){
    HPT1 = Seedlings
  }

                                        # Year 4 Record the HPT yields
  if(year < 14){
    HPT2 = HPT1
  }

                                        # Year 5 Record the HPT yields
  if(year < 13){
    HPT3 = setPheno(HPT2, varE = VarE, reps = repHPT, p = P[year+3L])
  }
                                        # Year 6 Select 500 superior individuals and plant as advanced clonal trials (ACT)
  if(year < 12){
    ACT1 = selectInd(HPT3, nInd = nClonesPhenoACT, use = "pheno")
  }

                                        # Year 7 Record ACT yields
  if(year < 11){
    ACT2 = ACT1
  }

                                        # Year 8 Record ACT yields
  if(year < 10){
    ACT3 = ACT2
  }

                                        # Year 9 Record ACT yields
  if(year < 9){
    ACT4 = ACT3
  }

                                        # Year 10 Record ACT yields
  if(year < 8){
    ACT5 = setPheno(ACT4, varE = VarE, reps = repACT, p = P[year+8L])
  }

                                        # Year 11 Select 30 superior individuals and plant as elite clonal trials (ECT)
  if(year < 7){
    ECT1 = selectInd(ACT5, nInd = nClonesPhenoECT, use = "pheno")
  }

                                        # Year 12 Record ECT yields
  if(year < 6){
    ECT2 = ECT1
  }

                                        # Year 13 Record ECT yields
  if(year < 5){
    ECT3 = ECT2
  }

                                        # Year 14 Record ECT yields
  if(year < 4){
    ECT4 = ECT3
  }

                                        # Year 15 Record ECT yields
  if(year < 3){
    ECT5 = ECT4
  }

                                        # Year 16 Record ECT yields
  if(year < 2){
    ECT6 = setPheno(ECT5, varE = VarE, reps = repECT, p = P[year+14L])
  }
}
