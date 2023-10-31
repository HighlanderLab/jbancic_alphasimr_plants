## -------------------------------------------------------------------------------
##
## Script name: Phenotypic clonal breeding program
##
## Authors: 
##
## Date Created: 2023-01-23
##
## Email:
##
## -------------------------------------------------------------------------------
##
## Description:
##
## adapted from Lubanga et al. 2022
## -------------------------------------------------------------------------------
rm(list = ls())

##-- Load packages
require("AlphaSimR")
scenarioName = "ClonalPheno"

##-- Load global parameters
source("GlobalParameters.R")

##-- Create list to store results from reps
results = list()

#create vectors for storing the summary data
for(REP in 1:nReps){
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

  ##-- Simulate year effects
  P = runif(nCycles)
  
  ##-- Burn-in phase
  for(year in 1:nBurnin)
  { 
    cat("  Working on burnin year:",year,"\n")
    source("UpdateParents.R")  # Pick parents
    source("AdvanceYear.R")    # Advances yield trials by a year and collects records
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
  }
  
  ##-- Future phase
  for(year in (nBurnin+1):(nBurnin+nFuture))
  { 
    cat("  Working on future year:",year,"\n")
    source("UpdateParents.R")  # Pick parents
    source("AdvanceYear.R")    # Advances yield trials by a year and collects records
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
  }
  
  # Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))
