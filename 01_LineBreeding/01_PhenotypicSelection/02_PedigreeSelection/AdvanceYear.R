#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

##Year 9
##Release variety

#Year 8
##PG: How does this compound naming scheme look?
S6_EYT = self(S5_AYT, nProgeny = nS6)
S6_EYT = setPheno(S6_EYT, varE = varE, reps = repS6)
S6_EYT = selectFam(S6_EYT, nFam = nS6_fam)

#Year 7
S5_AYT = self(S4_PYT, nProgeny = nS5)
S5_AYT = setPheno(S5_AYT, varE = varE, reps = repS5)
output$accSel[year] = accuracy_family(S5_AYT)
##I had to write this function to get accuracy from families.
S5_AYT = selectFam(S5_AYT, nFam = nS5_fam)

#Year 6
S4_PYT = self(S3, nProgeny = nS4)
S4_PYT = setPheno(S4_PYT, varE = varE, reps = repS4)
S4_PYT = selectFam(S4_PYT, nFam = nS4_fam)

#Year 5
S3 = self(S2, nProgeny = nS3)
S3 = setPheno(S3, varE = varE, reps = repS3)
S3 = selectFam(S3, nFam = nS3_fam)
S3 = selectWithinFam(S3, nS3_ind)

#Year 4
S2 = self(S1_HDRW, nProgeny = nS2)
S2 = setPheno(S2, varE = varE, reps = repS2)
S2 = selectFam(S2, nFam = nS2_fam)
S2 = selectWithinFam(S2, nS2_ind)

#Year 3
S1_HDRW = self(F2, nProgeny = nS1)
S1_HDRW = setPheno(S1_HDRW, varE = varE, reps = repS1)
S1_HDRW = selectFam(S1_HDRW, nFam = nS1_fam)
S1_HDRW = selectWithinFam(S1_HDRW, nS1_ind)


#Year 2
F2 = self(F1, nProgeny = nF2)

#Year 1
F1 = randCross(Parents, nCrosses)

