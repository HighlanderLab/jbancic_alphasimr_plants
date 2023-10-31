#-----------------------------------------------------------------------
# Create founders
#-----------------------------------------------------------------------

# Generate initial haplotypes
founderPop = runMacs(nChr = nChr,
                     nInd     = nParents,
                     segSites = nQtl + nSnp,
                     inbred   = TRUE,
                     species  = "WHEAT")
SP = SimParam$new(founderPop)

# Add SNP chip
SP$restrSegSites(nQtl, nSnp)
if(nSnp > 0){
  SP$addSnpChip(nSnp)
}

# Add traits: trait represents yield
SP$addTraitAG(nQtlPerChr = nQtl,
              mean       = initMeanG,
              var        = initVarG,
              varEnv     = initVarEnv,
              varGxE     = initVarGE)

# Collect pedigree
SP$setTrackPed(TRUE)
SP$setSexes("yes_sys")

# Create founder parents
Parents = newPop(founderPop)

# Add phenotype reflecting 2 years of evaluation in EYT
Parents = setPheno(Parents, varE = varE, reps = repEYT*2)
rm(founderPop)
