#This script demonstrates the implementation of mutagenesis. To easily
#demonstrate the generation of genetic variance, we start with a founder population that is
#close to fixation for the 0 allele at all its loci. Then we
#implement mutation at a high rate and observe that the genetic
#variance for our trait increases.

rm(list = ls())

##-- Load packages
require("AlphaSimR")

#Generate founder haplotypes -

#We use the newMapPop function to create a population
#with a manually determined genetic map, so that we can initialize it close to
#fixation for allele 0.

founderPop <- newMapPop(genMap = list((1:1000)/1000),
                        haplotypes =
                          list(matrix(sample(x= c(0,1),
                                             size = 1000,
                                             replace = TRUE,
                                             prob =c(0.9,0.1)),
                                      nrow=100,
                                      ncol=1000)))
SP = SimParam$new(founderPop)

# Add trait
SP$addTraitA(nQtlPerChr = 1000,
              mean       = 0,
              var        = 0.1)

# Create founder parents
Parents = newPop(founderPop)

##Genetic Variance before mutation
varG(Parents)

##Implement mutagenesis at a high rate for demonstration purposes
Parents_mutations = AlphaSimR:::mutate(Parents, returnPos = TRUE, mutRate =
                                                           1e-1)

#The parents after mutation are
Parents = Parents_mutations[[1]]

##The positions of the mutation are
mutations = Parents_mutations[[2]]

##Genetic Variance after mutation
varG(Parents)
