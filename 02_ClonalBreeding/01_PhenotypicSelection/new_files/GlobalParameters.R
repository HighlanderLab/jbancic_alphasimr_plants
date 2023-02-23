nReps =  2#30       # Number of simulation replications

#### Population parameters ####
nChr = 15                  # Number of chromosomes
nQtl = 160                 # Number of QTL per chromosome: 15 chr x 160 QTL = 2400 QTLs
nSnp = 600                 # Simulate SNP chip with 9000 markers
genLen =  1                # Genetic length
PhyLen =  1e+08            # Physical length
mutRate =  2.5e-08         # Mutation rate
nParents = 20              # Number of founders

nClonesPhenoACT       = 500      # Number of individuals selected at ACT stage in the phenotypic program
nClonesPhenoECT       = 40       # Number of individuals selected at ECT stage in the phenotypic program
ncloneSeedGScostACT   = 300      # Number of individuals selected at ACT stage in the Seed_GSconst
ncloneSeedGScostECT   = 40       # Number of individuals selected at ECT stage in the Seed_GSconst
ncloneSeedGSuncontACT = 500      # Number of individuals selected at ACT stage in the Seed_GSunconst
ncloneSeedGSuncontECT = 40       # Number of individuals selected at ECT stage in the Seed_GSunconst
ncloneECTGS           = 90       # Number of individuals selected at ECT stage in the ECT_GS

MeanP                 = 2500      # Phenotypic mean
VarGen                = 150000    # Genetic variance
VarGxY                = 150000     # Genotype-by-year interaction variance
VarE                  = 2800000 #single variance
repHPT                = 1 # (VarE/1 ; h2=0.05)
repACT                = 25 # (VarE/25 = 112,000 ; h2=0.45)
repECT                = 500 # (VarE/500; h2 = 0.65)

##Breeding program parameters
nBurnIn               = 4#40        # Number of Burn-in breeding cycles
nBreeding             = 40        # Number of future breeding cycles
nCycles               = nBurnIn + nBreeding  # Number of total years of breeding
ncross                = 100       # Number of crosses

nProgPheno            = 20        # Number of progenies per cross in the phenotypic program
nProgSeed_GSconst     = 8         # Number of progenies per cross in the Seed_GSconst program
nProgSeed_GSunconst   = 20        # Number of progenies per cross in the Seed_GSunconst program
nPrognProgECT_GS      = 8         # Number of progenies per cross in the ECT_GS
