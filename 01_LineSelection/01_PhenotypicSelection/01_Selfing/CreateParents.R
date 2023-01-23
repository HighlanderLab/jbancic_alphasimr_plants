# Generate initial haplotypes
FOUNDERPOP = runMacs(nInd=nParents, 
                     nChr=21, 
                     segSites=nQtl+nSnp,
                     inbred=TRUE, 
                     species="WHEAT")
SP = SimParam$new(FOUNDERPOP)
SP$restrSegSites(nQtl,nSnp)
if(nSnp>0){
  SP$addSnpChip(nSnp)
}
SP$addTraitAG(nQtl,initMeanG,initVarG,initVarEnv,initVarGE)

Parents = newPop(FOUNDERPOP)
#Add phenotype reflecting 2 years of evaluation in EYT
#ignoring GxY
Parents = setPheno(Parents,varE=varE,reps=repEYT*2)
rm(FOUNDERPOP)


