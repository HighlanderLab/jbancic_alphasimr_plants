#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

#Year 6
#Release variety


#Year 5
EYT = selectInd(AYT, nEYT)
EYT = setPheno(EYT, varE = varE, reps = repEYT)

#Year 4
AYT = selectInd(PYT, nAYT)
AYT = setPheno(AYT, varE = varE, reps = repAYT)

#Year 3 - apply genomic selection 
#NOTE: HDRW removed because phenotyping not needed
DH = setEBV(DH, gsModel)
output$accSel[year] = cor(DH@gv, DH@ebv)
PYT = selectWithinFam(DH, famMax,use = "ebv")
PYT = selectInd(PYT, nPYT, use="ebv")
PYT = setPheno(PYT, varE = varE, reps = repPYT)

#Year 2
DH = makeDH(F1, nDH)

#Year 1
F1 = randCross(Parents, nCrosses)
