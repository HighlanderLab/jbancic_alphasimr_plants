## ------------------------------------------------------------------------
##
## Script name: Phenotypic line breeding program with doubled haploid technology
##
## Authors: Chris Gaynor, Jon Bancic, Philip Greenspoon
##
## Date Created: 2023-01-23
##
## Email:
##
## ------------------------------------------------------------------------
##
## Description:
##
##
## ------------------------------------------------------------------------

##-- Load packages
require("AlphaSimR")

##-- Load global parameters
source("GlobalParameters.R")

##-- 
for(REP in 1:nReps) {
  cat("Working on REP:", REP,"\n")
  
  ##-- Create dataframe for tracking key parameters
  output = data.frame(year     = 1:nCycles,
                      rep      = rep(REP, nCycles),
                      scenario = rep("BURNIN", nCycles),
                      meanG    = numeric(nCycles),
                      varG     = numeric(nCycles),
                      accSel   = numeric(nCycles))
  
  ##-- Create initial parents
  source("CreateParents.R")
  
  ##-- Fill breeding pipeline with unique individuals from initial parents
  source("FillPipeline.R")
  
  ##-- Burn-in phase
  for(year in 1:20){ #Change to any number of desired years
    cat("Working on burnin year:",year,"\n")
    source("UpdateParents.R") #Pick parents
    source("AdvanceYear.R") #Advances yield trials by a year
    # Update results
    dhMean[year] = meanG(DH)
    dhVar[year] = varG(DH)
  }
  
  ##-- Future phase
  for(year in 21:40){ #Change to any number of desired years ##PG:
                      #changed to 21:40 so that it saves properly
    cat("Working on future year:",year,"\n")
    source("UpdateParents.R") #Pick parents
    source("AdvanceYear.R") #Advances yield trials by a year
    # Update results
    dhMean[year] = meanG(DH)
    dhVar[year] = varG(DH)
  }
}
## ------------------------------------------------------------------------
plot(dhMean, type = "b", xlab="Year", ylab="Genetic mean of DH lines")

## ------------------------------------------------------------------------
plot(dhVar, type = "b", xlab="Year", ylab="Genetic variance of DH lines")
