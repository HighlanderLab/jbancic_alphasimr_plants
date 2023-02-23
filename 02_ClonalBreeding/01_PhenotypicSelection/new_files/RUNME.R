rm(list = ls())
setwd("~/jbancic_alphasimr_plants/02_ClonalBreeding/01_PhenotypicSelection/new_files/")
library(AlphaSimR)
##Simulating parameters
# Models a single trait representing yield for tea breeding program at Unilever Tea Kenya

##-- Load global parameters
source("GlobalParameters.R")

#create vectors for storing the summary data
for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n")
  output = data.frame(year = 1:nCycles,
                      rep = rep(REP, nCycles),
                      scenario = rep("BURNIN", nCycles),
                      meanParent = numeric(nCycles),
                      varParent = numeric(nCycles),
                      meanSeed = numeric(nCycles),
                      meanACT = numeric(nCycles),
                      meanECT = numeric(nCycles),
                      varSeed = numeric(nCycles),
                      varACT = numeric(nCycles),
                      varECT = numeric(nCycles),
                      GenicVar = numeric(nCycles),
                      CovG_HW = numeric(nCycles),
                      accSeed = numeric(nCycles),
                      accACT = numeric(nCycles))


  ##-- Create initial parents
  source("CreateParents.R")

  ## Presample year p-value for genotype-by-year interactions
  ## These values are only used for filling the pipeline
  P = runif(15)

  ##-- Fill breeding pipeline with unique individuals from initial parents
  source("fillPipeline.R")

  ## Replace presampled p-values for all cycles of burn-in + future breeding
  ## These are used in the burn-in and future evaluation steps
  P = runif(nCycles)

  ## Run 40 cycle of breeding program
  for(year in 1:nBurnIn){
    cat(" Working on year ", year, "\n", sep = "")

    source("UpdateParents.R") #Pick parents

    source("AdvanceYear.R") #Advances yield trials by a year

        # Report mean and variance
    output$meanParent[year] = meanG(Parents)
    output$varParent[year] = varG(Parents)

    output$meanSeed[year] = meanG(Seedlings)
    output$meanACT[year] = meanG(ACT5)
    output$meanECT[year] = meanG(ECT6)

    output$varSeed[year] = varG(Seedlings)
    output$varACT[year] = varG(ACT5)
    output$varECT[year] = varG(ECT6)

    gp = genParam(Seedlings)
    output$GenicVar[year] = genicVarG(Seedlings)
    output$CovG_HW[year] = gp$covG_HW        #Genetic Covariance nonHWE


  }

  # Save output
  cat(paste0("saving REP ", REP, "\n"))
  save.image(paste0("BURNIN_", REP, ".RData"))
}





