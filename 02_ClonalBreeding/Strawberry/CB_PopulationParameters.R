### CALCULATE POPULATION PARAMETERS FOR SEEDLINGS, ST1, ST2 AND ST5

# Genetic mean, genetic variance and initial genomic heterozygosity (fraction of heterozygous QTL amongst all loci)

seedOutput$cycle[b] = b
seedOutput$gain[b] = meanG(seedlings)  
seedOutput$meanA[b] = mean(popParSeed$gv_a)
seedOutput$varG[b] = varG(seedlings)  
seedOutput$h2[b] = varG(seedlings)/varP(seedlings) 

seedHet = pullQtlGeno(seedlings)
seedHet = mean(rowMeans(1-abs(seedHet-1)))

seedOutput$Fcoeff[b] = 1 - (seedHet/seedHet0)
seedOutput$rEBV[b] = cor(seedlings@pheno, seedlings@gv)




st1Output$cycle[b] = b
st1Output$gain[b] = meanG(ST1)
st1Output$meanA[b] = mean(popParSt1$gv_a)
st1Output$varG[b] = varG(ST1)
st1Output$h2[b] = varG(ST1)/varP(ST1) 

st1Het = pullQtlGeno(ST1)
st1Het = mean(rowMeans(1-abs(st1Het-1)))

st1Output$Fcoeff[b] = 1 - (st1Het/st1Het0)
st1Output$rEBV[b] = cor(ST1@pheno, ST1@gv)


############

# st2Output$cycle[b] = b
# 
# st2Output$gain[b] = meanG(ST2)
# st2Output$varG[b] = varG(ST2)
# st2Output$varA[b] = varA(ST2) 
# st2Output$varD[b] = varD(ST2)
# st2Output$AvsD[b] = varA(ST2)/varD(ST2) 
# st2Output$h2[b] = varA(ST2)/varP(ST2) 
# st2Output$H2[b] = varG(ST2)/varP(ST2)
# 
# st2Het = pullQtlGeno(ST2)
# st2Het = mean(rowMeans(1-abs(st2Het-1)))
# st2Output$Fcoeff[b] = 1 - (st2Het/st2Het0)
# 
# st2GenParam = genParam(ST2, indValues =T)
# st2Output$rEBV[b] = cor(ST2@pheno, st2GenParam$bv)
# st2Output$rEGV[b] = cor(ST2@pheno, ST2@gv)
# 


st5Output$cycle[b] = b
st5Output$gain[b] = meanG(ST5)
st5Output$meanA[b] = mean(popParSt5$gv_a)
st5Output$varG[b] = varG(ST5)
st5Output$h2[b] = varG(ST5)/varP(ST5) 

st5Het = pullQtlGeno(ST5)
st5Het = mean(rowMeans(1-abs(st5Het-1)))
st5Output$Fcoeff[b] = 1 - (st5Het/st5Het0)

st5Output$rEBV[b] = cor(ST5@pheno, ST5@gv)

