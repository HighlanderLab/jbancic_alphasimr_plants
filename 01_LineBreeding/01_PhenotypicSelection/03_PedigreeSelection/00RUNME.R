## -------------------------------------------------------------------------------
##
## Script name: Phenotypic line breeding program with pedigree selection
##
## Authors: Chris Gaynor, Jon Bancic, Philip Greenspoon
##
## Date Created: 2023-01-23
##
## Email:
##
## -------------------------------------------------------------------------------
##
## Description:
##
##
## -------------------------------------------------------------------------------
rm(list = ls())

##-- Load packages
require("AlphaSimR")
source("ExtraFunctions.R")
scenarioName = "LinePheno_pedigree"

##-- Load global parameters
source("GlobalParameters.R")

##-- Create list to store results from reps
results = list()

for(REP in 1:nReps) {
  cat("Working on REP:", REP,"\n")
  ##-- Create a data frame to track key parameters
  output = data.frame(year     = 1:nCycles,
                      rep      = rep(REP, nCycles),
                      scenario = rep(scenarioName, nCycles),
                      meanG    = numeric(nCycles),
                      varG     = numeric(nCycles),
                      accSel   = numeric(nCycles))
  ##PG: Accuracy not currently being filled in

  ##-- Create initial parents
  source("CreateParents.R")

  ##-- Fill breeding pipeline with unique individuals from initial parents
  source("FillPipeline.R")
  ##-- Burn-in phase
  for(year in 1:nBurnin)
  {
    cat("  Working on burnin year:",year,"\n")
    source("UpdateParents.R") # Pick parents
    source("AdvanceYear.R")   # Advances yield trials by a year
    # Report results
    output$meanG[year] = meanG(mergePops(F2))
    output$varG[year]  = varG(mergePops(F2))
  }

  ##-- Future phase
  for(year in (nBurnin+1):(nBurnin+nFuture))
  {
    cat("  Working on future year:",year,"\n")
    source("UpdateParents.R") # Pick parents
    source("AdvanceYear.R")   # Advances yield trials by a year
    ## Report results
    output$meanG[year] = meanG(mergePops(F2))
    output$varG[year]  = varG(mergePops(F2))
  }

  ## Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))

