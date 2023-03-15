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

##-- Create initial parents
source("CreateParents.R")

##-- Fill breeding pipeline with unique individuals from initial parents
source("FillPipeline.R")

#create vectors for storing the summary data
for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n")
  output = data.frame(year = 1:nCycles,
                      rep = rep(REP, nCycles),
                      scenario = rep("BURNIN", nCycles),
                      meanG = numeric(nCycles),
                      varG = numeric(nCycles),
                      accSel = numeric(nCycles))


  ##-- Create initial parents
  source("CreateParents.R")

  ## Presample year p-value for genotype-by-year interactions
  ## These values are only used for filling the pipeline
  P = runif(15)

  ##-- Fill breeding pipeline with unique individuals from initial parents
  source("FillPipeline.R")

  ## Replace presampled p-values for all cycles of burn-in + future breeding
  ## These are used in the burn-in and future evaluation steps
  P = runif(nCycles)

  ## Run 40 cycle of breeding program
  for(year in 1:nBurnIn){
    cat(" Working on year ", year, "\n", sep = "")
    source("UpdateParents.R") #Pick parents
    source("AdvanceYear.R") #Advances yield trials by a year

    # Report mean and variance
    output$meanSeed[year] = meanG(Seedlings)
    output$varSeed[year] = varG(Seedlings)
  }

  # Save output
  cat(paste0("saving REP ", REP, "\n"))
  save.image(paste0("BURNIN_", REP, ".RData"))
}





