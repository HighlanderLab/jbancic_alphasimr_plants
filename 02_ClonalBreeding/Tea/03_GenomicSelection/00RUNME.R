## -------------------------------------------------------------------------------
##
## Script name: Pedigree tea clonal breeding program
##
## Authors: Nelson Lubanga, Jon Bancic
##
## Date Created: 2023-12-06
##
## Email:
##
## -------------------------------------------------------------------------------
##
## Description:
## Tea breeding program was adapted from Lubanga et al. 2023.
## -------------------------------------------------------------------------------
rm(list = ls())

##-- Load packages
require("AlphaSimR")
scenarioName = "ClonalGS"

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
  for(year in 1:nBurnin) { 
    cat("  Working on burnin year:",year,"\n")
    source("UpdateParents.R")  # Pick parents
    source("AdvanceYear.R")    # Advance yield trials by a year
    source("StoreTrainPop.R")  # Store training population
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
  }
  
  ##-- Future phase
  # Replace three early stages with genomic prediction
  rm(HPT1,HPT2,HPT3)
  
  for(year in (nBurnin+1):(nBurnin+nFuture)) { 
    cat("  Working on future year:",year,"\n")
    source("RunModel_GS.R")    # Run pedigree model
    source("UpdateParents.R")  # Pick parents
    source("AdvanceYear_GS.R") # Advance yield trials by a year
    source("StoreTrainPop.R")  # Store training population
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
  }
  
  # Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))

