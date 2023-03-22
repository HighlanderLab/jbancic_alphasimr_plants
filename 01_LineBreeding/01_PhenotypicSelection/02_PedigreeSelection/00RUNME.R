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
setwd("~/jbancic_alphasimr_plants/01_LineBreeding/01_PhenotypicSelection/02_PedigreeSelection/")
##-- Load packages
require("AlphaSimR")
scenarioName = "Line_Pheno_pedigree"

##-- Load global parameters
source("GlobalParameters.R")
##PG: below file contains a function to calculate between family accuracies
source("accuracy_selection_between_families.R")
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
    output$meanG[year] = meanG(F2)
    ##PG:Which stage should we use for
    ##this mean?
    output$varG[year]  = varG(F2)
  }

  ##-- Future phase
  for(year in (nBurnin+1):(nBurnin+nFuture))
  {
    cat("  Working on future year:",year,"\n")
    source("UpdateParents.R") # Pick parents
    source("AdvanceYear.R")   # Advances yield trials by a year
    # Report results
    output$meanG[year] = meanG(F2)
    output$varG[year]  = varG(F2)
  }

  ## Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))

