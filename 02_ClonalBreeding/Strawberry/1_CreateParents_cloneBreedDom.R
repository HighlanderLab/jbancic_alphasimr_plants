# Generate initial haplotypes

FOUNDERPOP = runMacs(nInd=nFounders, 
                     nChr=nChr, 
                     segSites=nQtl+nSnp,
                     inbred=FALSE, 
                     species=species)


SP = SimParam$new(FOUNDERPOP)
SP$addSnpChip(nSnpPerChr=nSnp)



### ADDITIVE TRAIT WITH GxE
SP$addTraitAG(nQtlPerChr=nQtl,mean=initMeanG,var=initVarG,
             varEnv = initVarEnv, varGxE = initVarGE)


### ADDITIVE + DOMINANT TRAIT WITH GxE
# SP$addTraitADG(nQtlPerChr=nQtl,mean=initMeanG,var=initVarG,
#                varEnv=initVarEnv, varGxE=initVarGE,
#                meanDD=domDeg, varDD=domDegreeVar, useVarA=T)





### FOUNDER POPULATION - 60 Individuals

founderpop = newPop(FOUNDERPOP)
founderpop = setPheno(founderpop,varE=eVarSt1, reps=repS3) ### varE here has to be defined using broad-sense heritability


# Heritability calculated based on varG and varE is broad-sense heritability
# Since dominance plays a role, and dominance is visible in performance when selecting based on phenotype, the heritability defined 
# in the simulations has to be broad-sense heritability (which is higher than narrow-sense used in selection based on BVs or EBVs)
# useVarA=F tunes to total genetic variance (narrow-sense heritability for parental selection will be smaller than the defined h2 in GlobalParameters)
# Therefore, the entry heritabilities defined for the simulations are broad-sense!



