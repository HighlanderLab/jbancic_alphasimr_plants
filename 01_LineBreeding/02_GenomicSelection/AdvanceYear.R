# Advance year

# Advance breeding program by 1 year
# Works backwards through pipeline to avoid copying data

# Stage 7
# Release variety

# Stage 6
EYT = selectInd(AYT, nEYT)
EYT = setPheno(EYT, varE = varE, reps = repEYT)

# Stage 5
AYT = selectInd(PYT, nAYT)
AYT = setPheno(AYT, varE = varE, reps = repAYT)

# Stage 4
output$accSel[year] = cor(HDRW@gv, HDRW@pheno)
PYT = selectWithinFam(HDRW, famMax)
PYT = selectInd(PYT, nPYT)
PYT = setPheno(PYT, varE = varE, reps = repPYT)

# Stage 3
HDRW = setPheno(DH, varE = varE, reps = repHDRW)

# Stage 2
DH = makeDH(F1, nDH)

# Stage 1
F1 = randCross(Parents, nCrosses)
