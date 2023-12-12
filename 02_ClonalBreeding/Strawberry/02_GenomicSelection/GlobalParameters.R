#-----------------------------------------------------------------------
# Global Parameters
#-----------------------------------------------------------------------

#-- Number of simulation replications and breeding cycles
nReps   = 1    # Number of simulation replicates
nBurnin = 20   # Number of years in burnin phase
nFuture = 20   # Number of years in future phase
nCycles = nBurnin + nFuture
startTP = 20   # Year to start training population

#-- Genome simulation
nChr    = 20      # Number of chromosomes
nQtl    = 1000    # Number of QTL per chromosome
nSnp    = 300     # Simulate SNP chip with 6000 markers
# genLen  = 1       # Genetic length
#PhyLen  = 1e+08   # Physical length
# mutRate = 2.5e-08 # Mutation rate

#-- Initial inbred parents mean and variance

#-- Initial parents mean and variance
initMeanG = 10  # Phenotypic mean
initVarG  = 1   # Genetic variance
# Degree of dominance
meanDD = 0.92   # mean
varDD  = 0.3    # variance
# Error variances 
initVarEnv = 1e-6        # No environmental variance
initVarGE  = 2*initVarG  # Genotype-by-year interaction (varGxE ~ 2 varG)
seedVarE   = 9           # Seedlings error variance
stageVarE  = 7/3         # Stage error variance

#-- Breeding program details
nParents   = 60  # Number of parents (and founders)
nCrosses   = 150 # Number of crosses
nProgeny   = 100 # Number of progenies per cross
maxFam     = 7   # Maximum number of progeny per cross to advance

# Number of individuals per stage
nS1 = 1000
nS2 = 100
nS3 = 20
nS4 = 5

# Effective replication of yield trials
repS2  = 2  # h2 = 0.46
repS3  = 4  # h2 = 0.63
repS45 = 6  # h2 = 0.74