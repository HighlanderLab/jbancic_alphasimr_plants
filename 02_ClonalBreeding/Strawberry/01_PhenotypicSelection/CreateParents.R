#-----------------------------------------------------------------------
# Create founders
#-----------------------------------------------------------------------

## Create founder population
founderPop = runMacs(nInd    = nParents,
                    nChr     = nChr,
                    segSites = nQtl+nSnp,
                    inbred   = FALSE,
                    ploidy   = 4,
                    species  = "GENERIC")

## Set simulation parameters
SP = SimParam$new(founderPop)

# Add SNP chip
SP$addSnpChip(nSnp)

# Add traits: trait represents yield
SP$addTraitADG(nQtlPerChr = nQtl,
               mean       = initMeanG,
               var        = initVarG, 
               meanDD     = meanDD,
               varDD      = varDD,
               varEnv     = initVarEnv,
               varGxE     = initVarGE, 
               useVarA = TRUE)

# Create founder parents
Parents = newPop(founderPop)

# Set a phenotype to founder parents
Parents = setPheno(Parents, varE = stageVarE, reps = repS3)

rm(founderPop)