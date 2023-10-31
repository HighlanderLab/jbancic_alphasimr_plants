#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

#Year 11
#Release variety

#Year 10
EYT = selectInd(AYT, nEYT)
EYT = setPheno(EYT, varE = varE, reps = repEYT)

#Year 9
AYT = selectInd(PYT, nAYT)
AYT = setPheno(AYT, varE = varE, reps = repAYT)

#Year 8
output$accSel[year] = cor(HDRW@gv, HDRW@pheno)
PYT = selectWithinFam(HDRW, famMax)
PYT = selectInd(PYT, nPYT)
PYT = setPheno(PYT, varE = varE, reps = repPYT)

#Year 7
HDRW = setPheno(S4, varE = varE, reps = repHDRW)

#Year 6
# Assume all seed germinates
# Take single seed from each plant
# Lines almost fully inbred
S4 = self(S3)

#Year 5
# Assume all seed germinates
# Take single seed from each plant
S3 = self(S2)

#Year 4
# Assume all seed germinates
# Take single seed from each plant
S2 = self(S1)

#Year 3
# Create segregating population
# Take single seed from each plant
S1 = self(S0, nSelf)

#Year 2
S0 = self(F1, nSelf)

#Year 1
F1 = randCross(Parents, nCrosses)

