#-----------------------------------------------------------------------
# Create founders
#-----------------------------------------------------------------------

# Generate initial haplotypes
founderPop = runMacs(nInd     = nParents,
                     nChr = nChromosomes,
                     segSites = nQtl + nSnp,
                     inbred   = TRUE,
                     species  = "WHEAT")
SP = SimParam$new(founderPop)


# Add SNP chip
SP$restrSegSites(nQtl, nSnp) ##PG: Not in Chris's
if(nSnp > 0){ ##PG: Not in Chris's
  SP$addSnpChip(nSnp)
}

# Add traits: trait represents yield
SP$addTraitAG(nQtlPerChr = nQtl, ##PG: Different from Chris's
              mean       = initMeanG,
              var        = initVarG,
              varEnv     = initVarEnv,
              varGxE     = initVarGE)

SP$setSexes("yes_sys") ##PG: Not in Chris's
SP$setVarE(h2=h2)

# Create founder parents
Parents = newPop(founderPop)

rm(founderPop)


