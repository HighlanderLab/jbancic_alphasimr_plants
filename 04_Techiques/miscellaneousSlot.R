## -------------------------------------------------------------------
## R Script: Use of miscellaneous slot in AlphaSimR
## -------------------------------------------------------------------
## Description:
## This script illustrates the usage of the miscellaneous slot in 
## AlphaSimR. The slot is specifically designed for storing extra 
## information about each individual in the population, which can 
## be leveraged as part of customized selection criteria.
## -------------------------------------------------------------------

# Load packages
rm(list = ls())
require("AlphaSimR")

# Create founder haplotypes
founderPop = runMacs(nInd     = 10,
                     nChr     = 1,
                     segSites = 100,
                     inbred   = TRUE,
                     species  = "GENERIC")


##-- Add two correlated additive traits with same genetic architecture
######################################################################
# Set simulation parameters
SP = SimParam$new(founderPop)

# Specify correlation between traits
(traitCor = matrix(c(1,0.5,
                     0.5,1), ncol = 2, byrow = T))

# Create two traits
SP$addTraitA(nQtlPerChr = 100,
             mean = c(0,0),
             var  = c(1,1),
             corA = traitCor)

# Create population 
pop = newPop(founderPop)
pop = setPheno(pop, h2 = c(0.5,0.5))

#-- Assign selection index values to the miscellaneous slot
#####################################################################
# Set weights for each trait
weights = c(1,0.5)

# Naive selection index
selIndex = pheno(pop) %*% weights

# Assign index values to miscellaneous slot
pop = setMisc(pop, "selIndex", selIndex)

# Function to obtain nice table of miscellaneous slot values
getMiscSlot <- function(pop) {
  require(dplyr)
  return(bind_rows(pop@misc))
}

# Check miscellaneous slot
getMiscSlot(pop)

# Function to perform selection based on miscellaneous slot
selectIndMisc <-  function(pop, nInd, use = "selIndex", selectTop = TRUE) {
  match.arg(arg = use, 
            choices = names(pop@misc[[1]]))
  response = matrix(unlist(getMisc(pop, use)), nrow = pop@nInd)
  if (is.matrix(response)) {
    stopifnot(ncol(response) == 1)
  }
  take = order(response, decreasing = selectTop)
  return(pop[take[1:nInd]])
}

# Perform selection using miscellaneous slot
selectIndMisc(pop, 1, use = "selIndex")@id


