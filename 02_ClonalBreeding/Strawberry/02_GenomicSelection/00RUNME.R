## -------------------------------------------------------------------------------
##
## Script name: Genomic selection strawberry clonal breeding program
##
## Authors: Christian Werner, Jon Bancic, Philip Greenspoon
##
## Date Created: 2023-12-06
##
## Email:
##
## -------------------------------------------------------------------------------
##
## Description:
##
## Strawberry breeding program was adapted from Werner et al. 2023. 
## Genomic selection is used to improve accuracy of selection in Seedlings 
## and ST1 stages.
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
                      varD     = numeric(nCycles),
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
    source("StoreTrainPop.R")  # Store training population
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
    output$varD[year]  = varD(Seedlings)
  }
  
  ##-- Future phase
  for(year in (nBurnin+1):(nBurnin+nFuture)) { 
    cat("  Working on future year:",year,"\n")
    source("RunModel_GS.R")      # Run pedigree model
    source("UpdateParents_GS.R") # Pick parents
    source("AdvanceYear_GS.R")   # Advance yield trials by a year
    source("StoreTrainPop.R")    # Store training population
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
    output$varD[year]  = varD(Seedlings)
  }
  
  # Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))
