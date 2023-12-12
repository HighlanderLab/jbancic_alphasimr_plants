
# GENOME 
species = "GENERIC"
nChr = 20
nQtl = 1000 
nSnp = 1000          # 20000k SNP chip

# TRAIT
initMeanG = 10         
initVarG = 1          
eVarSeed = 9           # -> varESeed = 19 -> h2 = 0.05; varESeed = 9 -> h2 = 0.1;
eVarSt1 = 7/3          # -> 1.5: h2 = 0.4;  3: h2=0.25; 7/3~2.33: h2=0.3


# dominance
#domDegreeVar = 0.2 

# environment
initVarEnv = 1e-6             # no environmental variance
initVarGE = 2*initVarG     # rule of thumb: varGxE ~ 2 varG



### BREEDING PROGRAM

# DURATION
brnIn <- 20
cycles <- 20



# PARENTS AND CROSSINGS

#Parents 
nFounders = 60
nParents = 60
newParents = 30   # new parents each year in phenotypic selection crossing pool


# Crosses produced in the different scenarios
nCrosses = 150
nCrossesGSseed = 130

# Lines produced per cross
nFamLines = 100          # number of progeny per cross : 150 x 100 = 15.000
nFamLinesGS = 91         # 150 x 91 = 13650  (25$/genotype*1000 = 25000$ -> /20 = -1250 seedlings /150 ~ -9/cross)
nFamLinesGSseed = 84     # 130 x 82 = 10660 (300000/25$ = 12000-1250 = 10750 /130 ~ -18/cross with 130 crosses)
nFamLinesGSseed2 = 42    # 130 x 41 x 2 = 10660; number of progeny per cross when 2 generation cycles per year are exploited


famMaxSeed = 7           # max. number of advanced seedlings per family. Only for FillPipeline

# Entries per stage 
nS1 = 1000
nS2 = 100
nS3 = 20
nS4 = 5


#Effective replications of yield trials to define heritabilities based on varEst1
repS2 = 2      # 0.46
repS3 = 4      # 0.63
repS45 = 6     # 0.72



