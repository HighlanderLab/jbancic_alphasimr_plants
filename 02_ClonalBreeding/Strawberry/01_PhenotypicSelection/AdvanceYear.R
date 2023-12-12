#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
# Advance breeding program by 1 year
# Works backwards through pipeline to avoid copying data

fixEff = year

#Year 7
#Release variety

#Year 6
ST5 = setPheno(ST4, varE = stageVarE, reps = repS45, p = P[year], fixEff = fixEff)
ST5@pheno = (ST4@pheno+ST5@pheno)/2

#Year 5
ST4 = selectInd(ST3, nS4)
ST4 = setPheno(ST4, varE = stageVarE, reps = repS45, p = P[year], fixEff = fixEff)

#Year 4
ST3 = selectInd(ST2, nS3)
ST3 = setPheno(ST3, varE = stageVarE, reps = repS3, p = P[year], fixEff = fixEff)

#Year 3
output$accSel[year] = cor(ST1@gv, ST1@pheno)
ST2 = selectInd(ST1, nS2)
ST2 = setPheno(ST2, varE = stageVarE, reps = repS2, p = P[year], fixEff = fixEff)

#Year 2
ST1 = selectInd(selectWithinFam(Seedlings, maxFam), nS1)
ST1 = setPheno(ST1, varE = stageVarE, rep = 1, p = P[year], fixEff = fixEff)

#Year 1
Seedlings = randCross(Parents, nCrosses, nProgeny)
Seedlings = setPheno(Seedlings, varE = seedVarE, reps = 1, p = P[year], fixEff = fixEff)