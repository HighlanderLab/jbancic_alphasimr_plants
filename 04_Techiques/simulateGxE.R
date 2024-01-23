# Script name: Simulation of genotype by environment interaction
#
# Authors: Jon Bancic, Philip Greenspoon, Chris Gaynor, Gregor Gorjanc
#
# Date Created: 2023-01-23
#
# This script demonstrates two approaches to simulate genotype by 
# environment with AlphaSimR:
# i) using a single latent environmental covariate
# ii) using correlated traits as environments 


# ---- Clean environment and load packages ----

rm(list = ls())
# install.packages(pkgs = "AlphaSimR")
packageDescription(pkg = "AlphaSimR")$Version
library(package = "AlphaSimR")

# ---- Setup simulation ----

# Create founder haplotypes
founderPop = runMacs(
  nInd     = 1000,
  nChr     = 1,
  segSites = 1000,
  inbred   = TRUE,
  species  = "WHEAT"
)


# ---- Using latent environment covariate ----

# Set simulation parameters
SP = SimParam$new(founderPop)

# Add additive and GxE trait
SP$addTraitAG(nQtlPerChr = 1000, 
              mean   = 5,
              var    = 1,
              varGxE = 2)
# Check trait slots
str(SP$traits)

# Create population
pop = newPop(founderPop)

# Simulate phenotypes for 5 environments with homogeneous error variance
pheno = data.frame(
  "Env1" = c(setPheno(pop, varE = 4, p = runif(1), onlyPheno = T)),
  "Env2" = c(setPheno(pop, varE = 4, p = runif(1), onlyPheno = T)),
  "Env3" = c(setPheno(pop, varE = 4, p = runif(1), onlyPheno = T)),
  "Env4" = c(setPheno(pop, varE = 4, p = runif(1), onlyPheno = T)),
  "Env5" = c(setPheno(pop, varE = 4, p = runif(1), onlyPheno = T))
  )
# Sample different p-value from uniform distribution for the environmental covariate

# Summarize per environment 
boxplot(pheno)
# Note that pairwise correlations between environments will be different each time
summary(cor(pheno)[upper.tri(cor(pheno))])

# Calculate mean across 5 environments and select top 10 genotypes
pop@pheno = as.matrix(rowMeans(pheno))
pop2 = selectInd(pop, nInd = 10)

# Check heritabilities
(1/(1+2/5+4/5)) # expected mean-line h2
cor(gv(pop),pheno(pop))^2 # observed mean-line h2

(1/(1+2/1+4/1)) # expected plot-level h2
mean(cor(gv(pop),pheno)^2) # observed plot-level h2



# ---- Simulate 5 correlated traits as environments ----

# Set simulation parameters
SP = SimParam$new(founderPop)

# Specify correlation between traits
set.seed(123)
nEnv = 5 # No. of environments
traitCor = matrix(0, nEnv, nEnv)
traitCor[upper.tri(traitCor)] = runif(nEnv * (nEnv - 1)/2, 0.4, 1)
traitCor = traitCor + t(traitCor); diag(traitCor) = 1
# traitCor = matrix(1, ncol = nEnv, nrow = nEnv) # no GxE
traitCor

# Create five traits
SP$addTraitAG(
  nQtlPerChr = 1000,
  mean = rep(5, nEnv),
  var  = rep(1, nEnv),
  varGxE = rep(2, nEnv),
  corA = traitCor
)

# Create population
pop = newPop(founderPop)

# Check difference between simulated and true correlations
summary(cov2cor(varG(pop))[upper.tri(cov2cor(varG(pop)))])
cov2cor(varG(pop))-traitCor

# Simulate phenotypes for 5 environments with homogeneous error variance
pop = setPheno(pop, varE = rep(4, nEnv))

# Summarize per environment 
boxplot(pheno(pop))
# Note that pairwise correlations between environments will be more or less constant
cov2cor(varP(pop))
summary(cor(pheno(pop))[upper.tri(cor(pheno(pop)))])

# Calculate mean across 5 environments and select top 10 genotypes
pheno = as.matrix(rowMeans(pop@pheno))
pop2 = pop[order(pheno, decreasing = T)][1:10]
# if selection based on fewer environments is desired, e.g. 3...
# pheno = as.matrix(rowMeans(pop@pheno[,1:3]))

# Check heritabilities
(1/(1+2/5+4/5)) # expected mean-line h2
cor(rowMeans(gv(pop)),pheno)^2 # observed mean-line h2

(1/(1+2/1+4/1)) # expected plot-level h2
mean(diag(cor(gv(pop),pop@pheno)))^2 # mean plot-level h2
