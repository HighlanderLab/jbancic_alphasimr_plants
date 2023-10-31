#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

#Year 8
#Release variety

#Year 7
EYT2 = setPheno(EYT1, varE = varE, reps = repEYT)
EYT2@pheno = (EYT1@pheno + EYT2@pheno)/2

#Year 6
EYT1 = selectInd(AYT, nEYT)
EYT1 = setPheno(EYT1, varE = varE, reps = repEYT)

#Year 5
AYT = selectInd(PYT, nAYT)
AYT = setPheno(AYT, varE = varE, reps = repAYT)

#Year 4
output$accSel[year] = cor(HDRW@gv, HDRW@pheno)
PYT = selectWithinFam(HDRW, famMax)
PYT = selectInd(PYT, nPYT)
PYT = setPheno(PYT, varE = varE, reps = repPYT)

#Year 3
HDRW = setPheno(DH, varE = varE, reps = repHDRW)

#Year 2
DH = makeDH(F1, nDH)

#Year 1
F1 = randCross(Parents, nCrosses)

