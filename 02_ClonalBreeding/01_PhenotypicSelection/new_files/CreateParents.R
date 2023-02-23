  ## Create founder population
  founderPop = runMacs2(nInd = nParents,
                        nChr = nChr,
                        segSites = nQtl+nSnp)

  ## Set simulation parameters
  SP = SimParam$new(founderPop)
  # Add traits: trait represents yield
  SP$addTraitADG(nQtlPerChr = nQtl,
                 mean = MeanP,
                 var = VarGen,
                 varGxE = VarGxY)
  # Add SNP chip
  SP$addSnpChip(nSnpPerChr = nSnp)

  SP$pedigree
  SP$setTrackPed(TRUE)
  SP$setSexes("yes_sys")

  # Create data.frame for results
  Parents = newPop(founderPop)

  #Set a phenotype for the initial parents in the founder population
  Parents = setPheno(Parents,
                     varE = VarE)
