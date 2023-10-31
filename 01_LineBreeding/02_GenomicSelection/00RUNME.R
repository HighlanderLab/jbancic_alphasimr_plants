## -------------------------------------------------------------------------------
##
## Script name: Genomic selection wheat line breeding program
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
## Applies GS to advance individuals from DH to make PYT as well as to select new
## parents from DH stage.
##
## -------------------------------------------------------------------------------

##-- Clean up the environment and directory
rm(list = ls())
# file.remove(file.edit(grep))

##-- Load packages
require("AlphaSimR")
scenarioName = "LineGS"

##-- Load global parameters
source("GlobalParameters.R")

##-- Create list to store results from reps
results = list()

for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n")

  ##-- Create a data frame to track key parameters
  output = data.frame(year     = 1:nCycles,
                      rep      = rep(REP, nCycles),
                      scenario = "",
                      meanG = numeric(nCycles),
                      varG  = numeric(nCycles),
                      acc_sel = numeric(nCycles))
  ##-- Create initial parents
  source("CreateParents.R")

  ##-- Fill breeding pipeline with unique individuals from initial parents
  source("FillPipeline.R")

  ##-- Simulate year effects
  P = runif(nCycles)

  ## -------------------------------------------------------------------------------
  ##-- Burn-in phase
  cat("--> Working on Burn-in \n")
  for(year in 1:nBurnin) {
    cat(" Working on burnin year:",year,"\n")
    source("UpdateParents.R") # Pick new parents
    source("AdvanceYear.R")   # Advance yield trials by a year
    source("StoreTrainPop.R") # Store training population
    # Report results
    output$meanG[year] = meanG(DH)
    output$varG[year]  = varG(DH)
  }

  ## -------------------------------------------------------------------------------
  ##-- Future phase: Genomic selection program
  cat("--> Working on Genomic line breeding program \n")
  for(year in (nBurnin+1):(nBurnin+nFuture)) {
    cat(" Working on future year:",year,"\n")
    source("RunGSModels.R")      # Run genomic model
    source("UpdateParents_GS.R") # Pick new parents
    source("AdvanceYear_GS.R")   # Advance yield trials by a year
    source("StoreTrainPop.R")    # Store training population
    # Report results
    output$meanG[year] = meanG(DH)
    output$varG[year]  = varG(DH)
  }

  # Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))
