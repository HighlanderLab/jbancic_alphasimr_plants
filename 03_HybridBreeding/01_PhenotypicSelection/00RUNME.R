## -------------------------------------------------------------------------------
##
## Script name: Phenotypic selection hybrid maize breeding program
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

##-- Clean up the environment and directory
rm(list = ls())
# file.remove(file.edit(grep))

##-- Load packages
require("AlphaSimR")
scenarioName = "HybridPheno"

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
                      meanG_inbred = numeric(nCycles),
                      varG_inbred  = numeric(nCycles),
                      meanG_hybrid = numeric(nCycles),
                      varG_hybrid  = numeric(nCycles),
                      acc_sel = numeric(nCycles),
                      cor = numeric(nCycles))
  
  ##-- Create initial parents and set testers
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
    source("UpdateTesters.R") # Pick new testers
    source("AdvanceYear.R")   # Advance yield trials by a year
    source("StoreTrainPop.R") # Store training population
    # Report results
    output$meanG_inbred[year] = (meanG(MaleInbredYT3) + meanG(FemaleInbredYT3))/2
    output$varG_inbred[year]  = (varG(MaleInbredYT3) + varG(FemaleInbredYT3))/2
    tmp = hybridCross(FemaleInbredYT3, MaleInbredYT3, returnHybridPop=TRUE)
    output$meanG_hybrid[year] = meanG(tmp)
    output$varG_hybrid[year]  = varG(tmp)
    tmp = calcGCA(tmp,use="gv")
    output$cor[year] = cor(c(tmp$GCAf[,2],tmp$GCAm[,2]),
                           c(FemaleInbredYT3@gv[,1],MaleInbredYT3@gv[,1]))
  }
  
  ## -------------------------------------------------------------------------------
  ##-- Future phase: Phenotypic program
  cat("--> Working on Phenotypic hybrid program \n")
  output$scenario <- "Pheno"
  for(year in (nBurnin+1):(nBurnin+nFuture)) { 
    cat(" Working on future year:",year,"\n")
    source("UpdateParents.R") # Pick new parents
    source("UpdateTesters.R") # Pick new testers
    source("AdvanceYear.R")   # Advance yield trials by a year
    # Report results
    output$meanG_inbred[year] = (meanG(MaleInbredYT3) + meanG(FemaleInbredYT3))/2
    output$varG_inbred[year]  = (varG(MaleInbredYT3) + varG(FemaleInbredYT3))/2
    tmp = hybridCross(FemaleInbredYT3, MaleInbredYT3, returnHybridPop=TRUE)
    output$meanG_hybrid[year] = meanG(tmp)
    output$varG_hybrid[year]  = varG(tmp)
    tmp = calcGCA(tmp,use="gv")
    output$cor[year] = cor(c(tmp$GCAf[,2],tmp$GCAm[,2]),
                           c(FemaleInbredYT3@gv[,1],MaleInbredYT3@gv[,1]))
  }
  
  # Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))
