#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

#Year 12
#Release variety

#Year 11
EYT2 = setPheno(EYT1, varE = varE, reps = repEYT)
EYT2@pheno = (EYT1@pheno + EYT2@pheno)/2

#Year 10
EYT1 = selectInd(AYT, nEYT)
EYT1 = setPheno(EYT1, varE = varE, reps = repEYT)

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
S4 = self(S3)

#Year 5
S3 = self(S2)

#Year 4
S2 = self(S1) ##PG How many seeds per selfing. I have stopped
    ##keeping more than 1 after S1, since homozygosity will already
    ##have declined

#Year 3
S1 = self(S0, nSelf)

#Year 2
S0 = self(F1, nSelf)

#Year 1
F1 = randCross(Parents, nCrosses)

