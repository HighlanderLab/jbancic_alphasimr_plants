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
nChromosomes = 1 #Number of chromosomes

#-- Initial parents mean and variance
initMeanG  = 0
initVarG   = 1
initVarEnv = 1e-6 # Virtually zero for consistency with 2-Part paper
initVarGE  = 2
h2 = 0.05

#-- Breeding program details
nParents = 20 # Simulates an equal number of landraces
nCrosses = 40 # Number of crosses per year


##Number of progeny per selfed individual in each stage
nF2 = 100
plantsPerRow = 20


##Number of individuals to select in each stage
nF2_ind = 10
nF3_ind = 4
nF4_ind = 4
nF5_ind = 4
nPYT     = 100 # Entries per preliminary yield trial
nAYT     = 50  # Entries per advanced yield trial
nEYT     = 10  # Entries per elite yield trial

##Number of rows to select in each stage
nF3_row = 10
nF4_row = 10
nF5_row = 10
nF6_row = 4

## Effective replication of yield trials
repF6 = 4/9
repPYT   = 1   #h2 =
repAYT   = 4   #h2 =
repEYT   = 8   #h2 =















