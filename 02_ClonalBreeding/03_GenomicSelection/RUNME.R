## Description 
## ------------------------------------------------------------------------
# This script runs 20 years of a wheat breeding program with double haploid 
# technology 

## ------------------------------------------------------------------------
# Load global parameters
source("GlobalParameters.R")

# Create initial parents
source("CreateParents.R")

# Fill breeding pipeline with unique individuals from initial parents
source("FillPipeline.R")

# Initialize variables for results
dhMean = dhVar = numeric(40)

# Burn-in phase
for(year in 1:20){ #Change to any number of desired years
  cat("Working on year:",year,"\n")
  source("UpdateParents.R") #Pick parents
  source("AdvanceYear.R") #Advances yield trials by a year
  # Update results
  dhMean[year] = meanG(DH)
  dhVar[year] = varG(DH)
}

# Future phase
for(year in 1:20){ #Change to any number of desired years
  cat("Working on year:",year,"\n")
  source("UpdateParents.R") #Pick parents
  source("AdvanceYear.R") #Advances yield trials by a year
  # Update results
  dhMean[year] = meanG(DH)
  dhVar[year] = varG(DH)
}

## ------------------------------------------------------------------------
plot(dhMean, type = "b", xlab="Year", ylab="Genetic mean of DH lines")

## ------------------------------------------------------------------------
plot(dhVar, type = "b", xlab="Year", ylab="Genetic variance of DH lines")
