## -------------------------------------------------------------------------------
##
## Script name: Run hybrid maize breeding programs
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
source("01_PhenotypicSelection/GlobalParameters.R")

for(REP in 1:1){
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
                      acc_sel2 = numeric(nCycles),
                      cor = numeric(nCycles))

  ##-- Create initial parents and set testers
  source("01_PhenotypicSelection/CreateParents.R")

  ##-- Fill breeding pipeline with unique individuals from initial parents
  source("01_PhenotypicSelection/FillPipeline.R")

  ##-- Simulate year effects
  P = runif(nCycles)
  
  ## -------------------------------------------------------------------------------
  ##-- Burn-in phase 
  cat("--> Working on Burn-in \n")
  for(year in 1:nBurnin) { 
    cat(" Working on burnin year:",year,"\n")
    source("01_PhenotypicSelection/UpdateParents.R") # Pick new parents
    source("01_PhenotypicSelection/UpdateTesters.R") # Pick new testers
    source("01_PhenotypicSelection/AdvanceYear.R")   # Advance yield trials by a year
    source("01_PhenotypicSelection/StoreTrainPop.R") # Store training population
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
  # Save burn-in to load later for subsequent scenarios
  save.image("tmp.RData")
  
  ## -------------------------------------------------------------------------------
  ##-- Future phase: Phenotypic program
  cat("--> Working on Phenotypic hybrid program \n")
  
  for(year in (nBurnin+1):(nBurnin+nFuture)) { 
    cat(" Working on future year:",year,"\n")
    source("01_PhenotypicSelection/UpdateParents.R") # Pick new parents
    source("01_PhenotypicSelection/UpdateTesters.R") # Pick new testers
    source("01_PhenotypicSelection/AdvanceYear.R")   # Advance yield trials by a year
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
  # Save results
  cat(" Saving results \n")
  Scenario  <- output$scenario <- "HybridPheno"
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
    source("02_GenomicSelection/UpdateTesters.R")    # Pick new testers
    source("02_GenomicSelection/AdvanceYear_GS.R")   # Advance yield trials by a year
    source("02_GenomicSelection/StoreTrainPop.R")    # Store training population
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
  # Save results
  cat(" Saving results \n")
  Scenario  <- output$scenario <- "HybridGS"
  file.name <- paste0("Results_",Scenario,".csv")
  write.table(output, file.name, sep = ",", 
              col.names = !file.exists(file.name), row.names = F, append = T)
  
  ## -------------------------------------------------------------------------------
  ##-- Future phase: Two-Part Genomic selection program 
  cat("--> Working on Two-Part Genomic hybrid program \n")
  load("tmp.RData")
  
  # New parameters for population improvement
  nCyclesPI = 2        # Number of cycles per year
  nParents  = 50       # Number of parents
  nCrossMalePI = 100   # Number of male crosses per cycle
  nCrossFemalePI = 100 # Number of female crosses per cycle
  nMaleF1PI   = 80     # Number of F1-PI to advance to PD 
  nFemaleF1PI = 80     # Number of F1-PI to advance to PD
  
  for(year in (nBurnin+1):(nBurnin+nFuture)) { 
    cat(" Working on future year:",year,"\n")
    source("03_GenomicSelection_TwoPart/RunGSModels.R")      # Run genomic model
    source("03_GenomicSelection_TwoPart/UpdateTesters.R")    # Pick new testers
    source("03_GenomicSelection_TwoPart/AdvanceYear_GSTP.R") # Advance yield trials by a year and cycle parents
    source("03_GenomicSelection_TwoPart/StoreTrainPop.R")    # Store training population
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
  # Save results
  cat(" Saving results \n")
  Scenario  <- output$scenario <- "HybridGSTP"
  file.name <- paste0("Results_",Scenario,".csv")
  write.table(output, file.name, sep = ",", 
              col.names = !file.exists(file.name), row.names = F, append = T)
}

# Remove temporary file
file.remove("tmp.RData")

# Analyze results
source("ANALYZERESULTS_all.R")
