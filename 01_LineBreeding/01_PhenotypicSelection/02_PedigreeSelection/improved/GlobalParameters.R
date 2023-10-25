#-----------------------------------------------------------------------
# Global Parameters
#-----------------------------------------------------------------------

#-- Number of simulation replications and breeding cycles
nReps   = 10      # Number of simulation replicates
nBurnin = 20      # Number of years in burnin phase
nFuture = 20      # Number of years in future phase
nCycles = nBurnin + nFuture

#-- Genome simulation
nQtl = 1000 # Number of QTL per chromosome
nSnp = 0    # Number of SNP per chromosome

#-- Initial parents mean and variance
initMeanG  = 0
initVarG   = 1
initVarEnv = 1e-6
initVarGE  = 2
varE       = 4 # Yield trial error variance, bushels per acre
               # Relates to error variance for an entry mean

#-- Breeding program details
nParents = 20
nCrosses = 30 # Number of crosses per year

##PG: We will have to figure out what numbers to use.

##Number of individuals per family to select in each stage
nS1_ind = 2
nS2_ind = 2
nS3_ind = 2

##Number of families to select in each stage
nS1_fam = 5
nS2_fam = 5
nS3_fam = 5
nS4_fam = 5
nS5_fam = 5
nS6_fam = 5

##Number of progeny per selfed individual in each stage
nF2 = 10
nS1 = 5
nS2 = 5
nS3 = 5
nS4 = 5
nS5 = 5
nS6 = 5

## Effective replication of yield trials
repS1 = 1
repS2 = 1
repS3 = 1
repS4 = 1
repS5 = 1
repS6 = 1





