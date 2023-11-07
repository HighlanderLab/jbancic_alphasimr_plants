#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

#Year 3
#Release variety

#Year 2
F1 <- setPheno(F1, varE = varE)
selected <- selectInd(F1,nParents)
output$accSel[year] <- cor(F1@gv,F1@pheno)

#Year 1
F1 <- randCross(Parents, nCrosses)

