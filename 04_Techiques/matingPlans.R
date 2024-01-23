# Script name: Simulation of mating designs in AlphaSimR
#
# Authors: Jon Bancic, Philip Greenspoon, Chris Gaynor, Gregor Gorjanc
#
# Date Created: 2023-01-23
#
# This script provides practical examples of specifying various 
# mating designs within AlphaSimR.

# ---- Clean environment and load packages ----

rm(list = ls())
# install.packages(pkgs = c("AlphaSimR", "ade4", "ggplot2")
library(package = "AlphaSimR")
library(package = "ade4")
library(package = "ggplot2")
source(file = "functions.R")

# ---- Setup simulation ----

founderPop = runMacs(
  nInd     = 40,
  segSites = 1000,
  inbred   = TRUE,
  split    = 100,
  species  = "MAIZE"
)

# Set simulation parameters
SP = SimParam$new(founderPop)

# Add trait with dominance
SP$addTraitAD(
  nQtlPerChr = 1000,
  mean   = 5,
  var    = 1,
  meanDD = 0.92)$
  setVarE(h2 = 0.3)

# Create a single population
pop = newPop(founderPop)

# Create two populations and testers
popA = selectCross(pop[1:10], nInd = 5, nCrosses = 10)
popB = selectCross(pop[11:20], nInd = 5, nCrosses = 10)
popC = selectCross(pop[21:30], nInd = 5, nCrosses = 10)
popD = selectCross(pop[31:40], nInd = 5, nCrosses = 10)
testerB = selectInd(popB, nInd = 2)

#-------------------------------------------------------------
# ---- Crosses within a single population ----

#### 1. Random cross ####
# Note: sample bi-parental crosses from full diallel
newPop = randCross(popA, nCrosses = 10, nProgeny = 100)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)

#### 2. Full diallel of bi-parental crosses (n x n) ####
# Note: bi-parental crosses in all possible combinations
# with reciprocal and self crosses
crossPlan = expand.grid(1:nInd(popA), 
                        1:nInd(popA))
newPop = makeCross2(popA, popA, crossPlan, nProgeny = 100)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)

#### 3. Partial diallel 1 (n + n(n-1)/2) ####
# Note: bi-parental crosses with self crosses and without reciprocal crosses 
crossPlan = cbind(
  unlist(lapply(popA@nInd:1, function(x) rep((popA@nInd+1)-x, x))),
  unlist(lapply(1:popA@nInd, function(x) x:popA@nInd))
  )
newPop = makeCross(popA, crossPlan, nProgeny = 18)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)

#### 4. Partial diallel 2 (n(n-1)/2) ####
# Note: bi-parental crosses without reciprocal crosses and self crosses 
crossPlan = cbind(
  unlist(lapply(popA@nInd:1, function(x) rep((popA@nInd+1)-x, x-1))),
  unlist(lapply(2:popA@nInd, function(x) x:popA@nInd))
  )
newPop = makeCross(popA, crossPlan, nProgeny = 22)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)

#### 5. Specified crosses with maximum avoidance ####
crossPlan = maxAvoidPlan(nInd = 10, nProgeny = 10)
newPop = makeCross(popA, crossPlan)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)

#### 6. Develop Multiparent Generation Intercross (MAGIC) population ####
Pop = c(popA[1:2],popB[1:2],popC[1:2],popD[1:2])
# Make 2-way crosses to produce F1 hybrids
crossPlan = cbind(c(1, 3, 5, 7),
                  c(2, 4, 6, 8))
newPop = makeCross(Pop, crossPlan)
table(newPop@father, newPop@mother) # visualize
# Make 4-way crosses to produce double cross hybrids
crossPlan = cbind(c(1, 3),
                  c(2, 4))
newPop = makeCross(newPop, crossPlan)
table(newPop@father, newPop@mother) # visualize
# Make 8-way crosses to produce quadruple cross hybrids
crossPlan = cbind(1, 2)
newPop = makeCross(newPop, crossPlan, nProgeny = 1000)
table(newPop@father, newPop@mother) # visualize
# Create inbred lines with single seed descent
for (i in 1:6) {
  newPop = self(newPop, nProgeny = 1)
}
# Check inbreeding
1 - mean(rowMeans(1 - abs(pullQtlGeno(pop) - 1)))
# Compare genetic mean and variance
meanG(Pop); meanG(newPop)
varG(Pop); varG(newPop)

# Visualize MAGIC with PCA
geno = pullQtlGeno(c(Pop, newPop))
PCA  = dudi.pca(df = geno, center = T, scale = F, scannf = F, nf = 5)
(VAF = 100 * PCA$eig[1:5] / sum(PCA$eig)) # variance explained
df.PCA = data.frame(
  "Pop" = c(rep("Parents", 8), rep("MAGIC", 1000)),
  "PC1" = PCA$l1$RS1,
  "PC2" = PCA$l1$RS2)
ggplot(df.PCA, aes(x = PC1, y = PC2)) +
  geom_point(aes(colour = factor(Pop))) +
  ggtitle("Population structure") +
  xlab(paste("Pcomp1: ", round(VAF[1], 2), "%", sep = "")) +
  ylab(paste("Pcomp2: ", round(VAF[2], 2), "%", sep = ""))

#-------------------------------------------------------------
# ---- Crosses among two populations ----

#### North Carolina I ####
# Note: each PopA parent is crossed to a different 
# group of parents in PopB
crossPlan = cbind(rep(1:3,each = 3), 
                  1:9)
newPop = makeCross2(popA, popB, crossPlan, nProgeny = 10)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)

#### Testcross/Topcross/North Carolina II ####
# Note: each PopA parent is crossed with every parent in PopB
crossPlan = expand.grid(1:nInd(popA), 
                        1:nInd(testerB))
newPop = makeCross2(popA, popB, crossPlan, nProgeny = 10)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)
# Check heterosis
calcHeterosis(popA, popB, newPop)

#### Factorial ####
crossPlan = expand.grid(1:nInd(popA), 
                        1:nInd(popB))
newPop = makeCross2(popA, popB, crossPlan, nProgeny = 10)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)
# Check heterosis
calcHeterosis(popA, popB, newPop)

#### Full diallel ####
crossPlan = expand.grid(1:nInd(popA), 
                        1:nInd(popB))
newPop = makeCross2(popA, popB, crossPlan, nProgeny = 10)
table(newPop@father, newPop@mother) # visualize
# Check genetic mean and variance
calcVar(newPop)
# Check heterosis
calcHeterosis(popA, popB, newPop)

#-------------------------------------------------------------
#### Complex multi-parental crosses ####
# Observe mean and variance change within and across families

#-- Factorial of bi-parental crosses
planSingle = cbind(rep(1:nInd(popA), each = nInd(popB)),
                   rep(1:nInd(popB), nInd(popA)))
F1 = makeCross2(popA, popB, nProgeny = 10, planSingle)
# Check genetic mean and variance
calcVar(F1)

#-- Backcross
planBack = cbind(1:nInd(F1), 
                 planSingle[,1])
BC1F1 = makeCross2(F1, popA, nProgeny = 10, planBack)
# Check genetic mean and variance
calcVar(BC1F1)

#-- 3-way crosses
plan3way = cbind(rep(1:nInd(F1), each = nInd(popC)), 
                 rep(1:nInd(popC), nInd(popA) * nInd(popB)))
F1_3way = makeCross2(F1, popC, nProgeny = 10, plan3way)
# Check genetic mean and variance
calcVar(F1_3way)

#-- Double crosses
F1_3x4 = makeCross2(popC, popD, planSingle)
planDouble = cbind(rep(1:nInd(F1), each = nInd(F1_3x4)),
                   rep(1:nInd(F1_3x4), nInd(F1)))
F1_double = makeCross2(F1, F1_3x4, planDouble)
