## -------------------------------------------------------------------------------
##
## Script name: Run wheat breeding programs
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
## This script runs both phenotypic and genomic selection program one after
## another.
##
## ------------------------------------------------------------------------------- 

##-- Clean up the environment and directory
rm(list = ls())
# file.remove(file.edit(grep))

##-- Load packages
require("AlphaSimR")

##-- Load global parameters
source("02_GenomicSelection/GlobalParameters.R")

for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n")
  
  ##-- Create a data frame to track key parameters
  output = data.frame(year     = 1:nCycles,
                      rep      = rep(REP, nCycles),
                      scenario = "",
                      meanG = numeric(nCycles),
                      varG  = numeric(nCycles),
                      acc_sel = numeric(nCycles))

  ##-- Create initial parents and set testers
  source("02_GenomicSelection/CreateParents.R")

  ##-- Fill breeding pipeline with unique individuals from initial parents
  source("02_GenomicSelection/FillPipeline.R")

  ##-- Simulate year effects
  P = runif(nCycles)
  
  ## -------------------------------------------------------------------------------
  ##-- Burn-in phase
  cat("--> Working on Burn-in \n")
  for(year in 1:nBurnin) {
    cat(" Working on burnin year:",year,"\n")
    source("02_GenomicSelection/UpdateParents.R") # Pick new parents
    source("02_GenomicSelection/AdvanceYear.R")   # Advance yield trials by a year
    source("02_GenomicSelection/StoreTrainPop.R") # Store training population
    # Report results
    output$meanG[year] = meanG(DH)
    output$varG[year]  = varG(DH)
  }
  # Save burn-in to load later for subsequent scenarios
  save.image("tmp.RData")
  
  ## -------------------------------------------------------------------------------
  ##-- Future phase: Phenotypic program
  cat("--> Working on Phenotypic hybrid program \n")
  for(year in (nBurnin+1):(nBurnin+nFuture)) { 
    cat(" Working on future year:",year,"\n")
    source("02_GenomicSelection/UpdateParents.R") # Pick new parents
    source("02_GenomicSelection/AdvanceYear.R")   # Advance yield trials by a year
    source("02_GenomicSelection/StoreTrainPop.R") # Store training population
    # Report results
    output$meanG[year] = meanG(DH)
    output$varG[year]  = varG(DH)
  }
  # Save results
  cat(" Saving results \n")
  Scenario  <- output$scenario <- "LinePheno"
  file.name <- paste0("Results_",Scenario,".csv")
  write.table(output, file.name, sep = ",", 
              col.names = !file.exists(file.name), row.names = F, append = T)
  
  ## -------------------------------------------------------------------------------
  ##-- Future phase: Genomic selection program 
  cat("--> Working on Genomic hybrid program \n")
  load("tmp.RData")
  for(year in (nBurnin+1):(nBurnin+nFuture)) { 
    cat(" Working on future year:",year,"\n")
    source("02_GenomicSelection/RunGSModels.R")      # Run genomic model
    source("02_GenomicSelection/UpdateParents_GS.R") # Pick new parents
    source("02_GenomicSelection/AdvanceYear_GS.R")   # Advance yield trials by a year
    source("02_GenomicSelection/StoreTrainPop.R")    # Store training population
    # Report results
    output$meanG[year] = meanG(DH)
    output$varG[year]  = varG(DH)
  }
  # Save results
  cat(" Saving results \n")
  Scenario  <- output$scenario <- "LineGS"
  file.name <- paste0("Results_",Scenario,".csv")
  write.table(output, file.name, sep = ",", 
              col.names = !file.exists(file.name), row.names = F, append = T)
  
  ## -------------------------------------------------------------------------------
  ##-- Future phase: Two-Part Genomic selection program 
  cat("--> Working on Two-Part Genomic hybrid program \n")
  load("tmp.RData")
  
  # New parameters for population improvement
  nCyclesPI = 4    # Number of rapid cycles per year
  nParents  = 50   # Number of parents
  nCrossPI  = 100  # Number of crosses per cycle
  nF1PI = 100      # Number of F1-PI to advance to PD 
  # Create a data frame to track selection accuracy in PI
  accPI = data.frame(accPI = numeric(nFuture*nCyclesPI))
  
  for(year in (nBurnin+1):(nBurnin+nFuture)) {
    cat(" Working on future year:",year,"\n")
    source("03_TwoPartGS/RunGSModels.R")      # Run genomic model
    source("03_TwoPartGS/AdvanceYear_GSTP.R")   # Advance yield trials by a year
    source("03_TwoPartGS/StoreTrainPop.R")    # Store training population
    # Report results
    output$meanG[year] = meanG(DH)
    output$varG[year]  = varG(DH)
  }
  # Save results
  cat(" Saving results \n")
  Scenario  <- output$scenario <- "LineGSTP"
  file.name <- paste0("Results_",Scenario,".csv")
  write.table(output, file.name, sep = ",", 
              col.names = !file.exists(file.name), row.names = F, append = T)
}

# Remove temporary file
file.remove("tmp.RData")

# Analyze results
source("ANALYZERESULTS_all.R")
