#!/exports/cmvm/eddie/eb/groups/HighlanderLab/communal/R-4.1.3/R-4.1.3/bin/Rscript
#$ -N Burnin
#$ -cwd
#$ -R y
#$ -pe sharedmem 4
#$ -l h_vmem=4G
#$ -l h_rt=05:00:00
#$ -j y
#$ -V
#$ -P roslin_HighlanderLab
#$ -M jbancic@exseed.ed.ac.uk

rm(list = ls())
library(AlphaSimR)
##Simulating parameters
# Models a single trait representing yield for tea breeding program at Unilever Tea Kenya

nReps =  30       # Number of simulation replications

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
nBurnIn               = 40        # Number of Burn-in breeding cycles
nBreeding             = 40        # Number of future breeding cycles
nCycles               = nBurnIn + nBreeding  # Number of total years of breeding
ncross                = 100       # Number of crosses

nProgPheno            = 20        # Number of progenies per cross in the phenotypic program
nProgSeed_GSconst     = 8         # Number of progenies per cross in the Seed_GSconst program
nProgSeed_GSunconst   = 20        # Number of progenies per cross in the Seed_GSunconst program
nPrognProgECT_GS      = 8         # Number of progenies per cross in the ECT_GS

#create vectors for storing the summary data
for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n") 
  output = data.frame(year = 1:nCycles,
                      rep = rep(REP, nCycles),
                      scenario = rep("BURNIN", nCycles),
                      meanParent = numeric(nCycles),
                      varParent = numeric(nCycles),
                      meanSeed = numeric(nCycles),
                      meanACT = numeric(nCycles),
                      meanECT = numeric(nCycles),
                      varSeed = numeric(nCycles),
                      varACT = numeric(nCycles),
                      varECT = numeric(nCycles),
                      GenicVar = numeric(nCycles),
                      CovG_HW = numeric(nCycles),
                      accSeed = numeric(nCycles),
                      accACT = numeric(nCycles))
  
  
  ## Create founder population
  founderPop = runMacs2(nInd = nParents, 
                        nChr = nChr, 
                        segSites = nQtl+nSnp)
  
  ## Set simulation parameters
  SP = SimParam$new(founderPop)
  # Add traits: trait represents yield
  SP$addTraitADG(nQtlPerChr = nQtl,
                 mean = MeanP,
                 var = VarGen,
                 varGxE = VarGxY)
  # Add SNP chip
  SP$addSnpChip(nSnpPerChr = nSnp)
  
  SP$pedigree
  SP$setTrackPed(TRUE)
  SP$setSexes("yes_sys")
  
  # Create data.frame for results
  Parents = newPop(founderPop)
  
  #Set a phenotype for the initial parents in the founder population
  Parents = setPheno(Parents,
                     varE = VarE)
  
  # Presample year p-value for genotype-by-year interactions
  # These values are only used for filling the pipeline
  P = runif(15)
  for(year in 1:16){
    # Year 1
    # Crossing block
    F1 = randCross(Parents, nCrosses=ncross, nProgeny = nProgPheno)
    
    # Year 2 Germinate the seedlings in the nursery
    if(year < 16){
      Seedlings = setPheno(F1, varE = VarE, reps = repHPT, p = P[year])
      
    }
    
    # Year 3 Plant in the seedlings in the field as HPT and record yields
    if(year < 15){
      HPT1 = Seedlings
    }
    
    # Year 4 Record the HPT yields
    if(year < 14){
      HPT2 = HPT1
    }
    
    # Year 5 Record the HPT yields
    if(year < 13){
      HPT3 = setPheno(HPT2, varE = VarE, reps = repHPT, p = P[year+3L])
    }
    # Year 6 Select 500 superior individuals and plant as advanced clonal trials (ACT)
    if(year < 12){
      ACT1 = selectInd(HPT3, nInd = nClonesPhenoACT, use = "pheno")
    }
    
    # Year 7 Record ACT yields
    if(year < 11){
      ACT2 = ACT1
    }
    
    # Year 8 Record ACT yields
    if(year < 10){
      ACT3 = ACT2
    }
    
    # Year 9 Record ACT yields
    if(year < 9){
      ACT4 = ACT3
    }
    
    # Year 10 Record ACT yields
    if(year < 8){
      ACT5 = setPheno(ACT4, varE = VarE, reps = repACT, p = P[year+8L])
    }
    
    # Year 11 Select 30 superior individuals and plant as elite clonal trials (ECT)
    if(year < 7){ 
      ECT1 = selectInd(ACT5, nInd = nClonesPhenoECT, use = "pheno")
    }
    
    # Year 12 Record ECT yields
    if(year < 6){
      ECT2 = ECT1
    }
    
    # Year 13 Record ECT yields
    if(year < 5){
      ECT3 = ECT2
    }
    
    # Year 14 Record ECT yields
    if(year < 4){
      ECT4 = ECT3
    }
    
    # Year 15 Record ECT yields
    if(year < 3){
      ECT5 = ECT4
    }
    
    # Year 16 Record ECT yields
    if(year < 2){
      ECT6 = setPheno(ECT5, varE = VarE, reps = repECT, p = P[year+14L])
    }
  }
  # Replace presampled p-values for all cycles of burn-in + future breeding
  # These are used in the burn-in and future evaluation steps
  P = runif(nCycles)
  
  # Run 40 cycle of breeding program
  for(year in 1:nBurnIn){
    cat(" Working on year ", year, "\n", sep = "")
    Parents = selectInd(ECT6, nInd = 20, use = "pheno")
    
    # Year 16
    ECT6 = setPheno(ECT5, varE = VarE, reps = repECT, p = P[year])
    
    # Year 15
    ECT5 = ECT4
    
    # Year 14
    ECT4 = ECT3
    
    # Year 13
    ECT3 = ECT2
    
    # Year 12
    ECT2 = ECT1
    
    # Year 11
    ECT1 = selectInd(ACT5, nInd = nClonesPhenoECT, use = "pheno")
    
    # Year 10
    ACT5 = setPheno(ACT4, varE = VarE, reps = repACT, p = P[year])
    
    # Year 9
    ACT4 = ACT3
    
    # Year 8
    ACT3 = ACT2
    
    # Year 7
    ACT2 = ACT1
    
    # Year 6
    output$accSeed[year] = cor(gv(HPT3),pheno(HPT3)) # accuracy based on 2000 inds
    ACT1 = selectInd(HPT3, nInd = nClonesPhenoACT, use = "pheno")
    
    # Year 5
    HPT3 = setPheno(HPT2, varE = VarE, reps = repHPT, p = P[year])
    
    # Year 4
    HPT2 = HPT1
    
    # Year 3
    HPT1 = Seedlings
    
    # Year 2
    Seedlings = setPheno(F1, varE = VarE, reps = repHPT, p = P[year])
    
    # Year 1
    # Crossing block
    F1 = randCross(Parents, nCrosses=ncross, nProgeny = nProgPheno)
    
    # Create pedigree as well as training population for GS
    ACT5@fixEff <- as.integer(rep(year,nInd(ACT5)))
    
    if(year==35){
      trainPop = ACT5
      ped = data.frame(Ind = c(ACT5@id),
                       Sire = c(ACT5@father),
                       Dam = c(ACT5@mother),
                       Year = year,
                       Stage = c(rep("ACT5",ACT5@nInd)),
                       Pheno = c(ACT5@pheno))
    } else if(year>35){
      trainPop = c(trainPop,ACT5)
      ped = rbind(ped,
                  data.frame(Ind = c(ACT5@id),
                             Sire = c(ACT5@father),
                             Dam = c(ACT5@mother),
                             Year = year,
                             Stage = c(rep("ACT5",ACT5@nInd)),
                             Pheno = c(ACT5@pheno)))
    }
    
    # Report mean and variance
    output$meanParent[year] = meanG(Parents)
    output$varParent[year] = varG(Parents)
    
    output$meanSeed[year] = meanG(Seedlings)
    output$meanACT[year] = meanG(ACT5)
    output$meanECT[year] = meanG(ECT6)
    
    output$varSeed[year] = varG(Seedlings)
    output$varACT[year] = varG(ACT5)
    output$varECT[year] = varG(ECT6)
    
    gp = genParam(Seedlings)
    output$GenicVar[year] = genicVarG(Seedlings)  
    output$CovG_HW[year] = gp$covG_HW        #Genetic Covariance nonHWE
    
    
  }
  
  # Save output
  cat(paste0("saving REP ", REP, "\n"))
  save.image(paste0("BURNIN_", REP, ".RData"))
}

