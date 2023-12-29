# Script name: Phenotypic tea clonal breeding program
#
# Authors: Initially developed by Nelson Lubanga, Gregor Gorjanc, Jon Bancic;
# exanded/polished for this publication by Jon Bancic, Philip Greenspoon,
# Chris Gaynor, Gregor Gorjanc
#
# Date Created: 2023-12-06

# ---- Clean environment and load packages ----
rm(list = ls())
# install.packages(pkgs = "AlphaSimR")
library(package = "AlphaSimR")

# ---- Load global parameters ----
source(file = "GlobalParameters.R")
scenarioName = "ClonalPheno"

# ---- Create list to store results from reps ----
results = list()

for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n")

  # ---- Create a data frame to track key parameters ----
  output = data.frame(year     = 1:nCycles,
                      rep      = rep(REP, nCycles),
                      scenario = rep(scenarioName, nCycles),
                      meanG    = numeric(nCycles),
                      varG     = numeric(nCycles),
                      accSel   = numeric(nCycles))

  # ---- Create initial parents ----
  source(file = "CreateParents.R")

  # ---- Fill breeding pipeline with unique individuals from initial parents ----
  source(file = "FillPipeline.R")

  # ---- Simulate year effects ----
  P = runif(nCycles)

  # ---- Burn-in phase ----
  for(year in 1:nBurnin) {
    cat("  Working on burnin year:",year,"\n")
    source(file = "UpdateParents.R")  # Pick parents
    source(file = "AdvanceYear.R")    # Advances yield trials by a year and collects records
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
  }

  # ---- Future phase ----
  for(year in (nBurnin+1):(nBurnin+nFuture)) {
    cat("  Working on future year:",year,"\n")
    source(file = "UpdateParents.R")  # Pick parents
    source(file = "AdvanceYear.R")    # Advances yield trials by a year and collects records
    # Report results
    output$meanG[year] = meanG(Seedlings)
    output$varG[year]  = varG(Seedlings)
  }

  # Save results from current replicate
  results = append(results, list(output))
}

# Save results
saveRDS(results, file = paste0(scenarioName,".rds"))
