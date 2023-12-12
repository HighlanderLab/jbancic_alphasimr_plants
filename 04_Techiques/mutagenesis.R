# This script demonstrates the implementation of mutagenesis. 
# To easily demonstrate the generation of genetic variance, 
# we start with a founder population that is close to fixation 
# for the 0 allele at all its loci. Then we implement mutation 
# at a high rate and observe that the genetic variance for our 
# trait increases.

##-- Load packages
rm(list = ls())
require("AlphaSimR")

##-- Generate founder haplotypes
# We use the newMapPop function to create a population
# with a manually determined genetic map, so that we 
# can initialize it close to fixation for allele 0.
founderPop = 
  newMapPop(genMap = list((1:1000)/1000),
            haplotypes = list(matrix(sample(x = c(0,1),
                                            size = 1000,
                                            replace = TRUE,
                                            prob = c(0.9,0.1)),
                                      nrow=100, ncol=1000)))
# Set simulation parameters
SP = SimParam$new(founderPop)

# Add trait
SP$addTraitA(nQtlPerChr = 1000,
              mean      = 0,
              var       = 0.1)

# Create population 
pop = newPop(founderPop)

# Genetic variance before mutation
varG(pop)

##-- Implement mutagenesis at a high rate for demonstration purposes
pop_mutations = AlphaSimR:::mutate(pop, 
                                   returnPos = TRUE, 
                                   mutRate   = 1e-1)

# The pop after mutation are
pop2 = pop_mutations[[1]]

# The positions of the mutation are
mutations = pop_mutations[[2]]

##-- Genetic variance after mutation
varG(pop)  # old variance 
varG(pop2) # new variance
