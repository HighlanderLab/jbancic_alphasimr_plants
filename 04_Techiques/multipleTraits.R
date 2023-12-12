# This script first demonstrates how to simulate (i) two correlated 
# traits with the same genetic architecture or (ii) two traits with 
# different genetic architecture and no QTLs in common in AlphaSimR
#
# The script also demonstrates how to perform naive or Hazel-Smith
# index selection with pre-assigned weights

# Load packages
rm(list = ls())
require("AlphaSimR")

# Create founder haplotypes
founderPop = runMacs(nInd     = 100,
                     nChr     = 1,
                     segSites = 500,
                     inbred   = TRUE,
                     species  = "WHEAT")



##-- Add two correlated additive traits with same genetic architecture
######################################################################
# Set simulation parameters
SP = SimParam$new(founderPop)

# Specify correlation between traits
(traitCor = matrix(c(1,0.5,
                    0.5,1), ncol = 2, byrow = T))

# Create two traits
SP$addTraitA(nQtlPerChr = 100,
             mean = c(0,0),
             var  = c(1,1),
             corA = traitCor)

# Create population 
pop = newPop(founderPop)

# Check genetic values and mean
gv(pop); meanG(pop)
# Check correlation between traits
cov2cor(varG(pop)) 



##-- Add two traits with different genetic architecture and no
# QTLs in common
#####################################################################
# Set simulation parameters
SP = SimParam$new(founderPop)

# Add first quantitative trait with dominance
SP$addTraitAD(nQtlPerChr = 100,
              mean   = 0,
              var    = 1,
              meanDD = 0.9, 
              varDD  = 0.1)

# Remove QTLs used by trait 1 --- TO ADD ONCE FIXED


# Add second additive oligogenic trait 
SP$addTraitA(nQtlPerChr = 2,
             mean = 0,
             var  = 1)

# Create population 
pop = newPop(founderPop)

# Check that no QTLs are in common

# Check genetic values and mean
gv(pop); meanG(pop)
# Check correlation between traits
cov2cor(varG(pop)) 



##-- Apply selection index
#####################################################################
# Set weights for each trait
weights = c(1,0.5)

# Set phenotype
pop = setPheno(pop, h2 = c(0.5,0.5))

##- Option 1: Apply naive index
# Naive selection index
naiveIndex = pheno(pop) %*% weights

# Select 10 best individuals using index function
pop2 = selectInd(pop, nInd = 10, 
                 trait = selIndex, # Index function
                 b = weights)      # provide weights
#Alternatively, manually select 10 best individuals using index values
pop2 = pop[order(naiveIndex, decreasing = T)][1:10]

##- Option 2: Apply Smith-Hazel index
#Calculate Smith-Hazel weights with known variances
b = smithHazel(weights, varG = varG(pop), varP = varP(pop))

# Select 10 best individuals using index function
pop3 = selectInd(pop, nInd = 10, 
                 trait = selIndex, # Index function
                 b = b)            # provide weights
# Alternatively, manually select 10 best individuals using index values
hazelIndex = selIndex(Y = pop@pheno, b = b)
pop3 = pop[order(hazelIndex, decreasing = T)][1:10]

# Check correlation between naive and Smith-Hazel index
cor(naiveIndex, hazelIndex)


