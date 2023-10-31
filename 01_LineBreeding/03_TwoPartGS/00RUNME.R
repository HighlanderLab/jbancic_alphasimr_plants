## -------------------------------------------------------------------------------
##
## Script name: Two-part wheat line breeding program
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
## Uses two-part strategy with rapid cycling of parents in population improvement 
## and conventional breeding for product development. Applies GS to advance 
## individuals from DH to make PYT as well as in population improvement. 
##
## -------------------------------------------------------------------------------

##-- Clean up the environment and directory
rm(list = ls())
# file.remove(file.edit(grep))

##-- Load packages
require("AlphaSimR")
scenarioName = "LineGSTP"

##-- Load global parameters
source("GlobalParameters.R")

##-- Create list to store results from reps
results = list()
results_accPI = list()

for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n")

  ##-- Create a data frame to track key parameters
  output = data.frame(year     = 1:nCycles,
                      rep      = rep(REP, nCycles),
                      scenario = "",
                      meanG = numeric(nCycles),
                      varG  = numeric(nCycles),
                      acc_sel  = numeric(nCycles),
                      acc_sel2 = numeric(nCycles))
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
  cat("--> Working on Two-part line breeding program \n")
  # New parameters for population improvement
  nCyclesPI = 4    # Number of rapid cycles per year
  nParents  = 50   # Number of parents
  nCrossPI  = 100  # Number of crosses per cycle
  nF1PI = 100      # Number of F1-PI to advance to PD 
  # Create a data frame to track selection accuracy in PI
  accPI = data.frame(accPI = numeric(nFuture*nCyclesPI))
  
  for(year in (nBurnin+1):(nBurnin+nFuture)) {
    cat(" Working on future year:",year,"\n")
    source("RunGSModels.R")      # Run genomic model
    source("AdvanceYear_GSTP.R")   # Advance yield trials by a year
    source("StoreTrainPop.R")    # Store training population
    # Report results
    output$meanG[year] = meanG(DH)
    output$varG[year]  = varG(DH)
  }

  # Save results from current replicate
  results = append(results, list(output))
  results_accPI = append(results_accPI, list(accPI))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))
saveRDS(results_accPI, file = paste0(scenarioName,"_accPI.rds"))
