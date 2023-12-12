#!/exports/cmvm/eddie/eb/groups/tier2_hickey_group/Programs/R-4.0.0/bin/Rscript
#$ -cwd
#$ -R y
#$ -pe sharedmem 10
#$ -l h_vmem=8G
#$ -l h_rt=50:00:00
#$ -j y
#$ -V
#$ -m ea
#$ -M christian.werner@roslin.ed.ac.uk 
#$ -l h='!node1f01.ecdf.ed.ac.uk&!node1f02.ecdf.ed.ac.uk'


library(AlphaSimR)
Rcpp::sourceCpp("AddCrossing_wLogfile_corr.cpp")
source("makeCrossMultProgeny.R")

ocsDegree = 0
#domDegree <- "01"
#domDeg <- 0.1
#JOB = 1


#### AUTO-DEFINE SIMULATION PARAMETERS HERIT AND DOMDEG BASED ON WORKING DIRECTORY

specs <- getwd()
domDegree <- gsub(".*domDeg_","", specs)
rm(specs)
JOB = Sys.getenv("SGE_TASK_ID")

load(paste0("CbBURNIN-",JOB,"_",domDegree,".RData"))
REP = JOB
JOB = paste0("SeedGS3-OCS0", JOB)


######################### GS-SEED SCENARIO ###################################


nFamLines = 40 #nFamLinesGSseed
nCrosses = 100 #nCrossesGSseed     # 130 Crosses
targAngle <- ocsDegree*pi/180 # OCS angle in rad


cat(paste0("\n","GS in Stage 1","\n"))

f1Acc <- matrix(NA,nrow=cycles+1, ncol=3) # 3 cycles per year = 3 prediction accuracies

for(c in 1:cycles){ 
  w=wEff[c]
  b=brnIn+c
  cat(paste0("cycle",b,"\n"))
  
  
  cat("  -> Calculate EBVs and EGVs\n")
  
  gs = RRBLUP(pop=trainPop) 

  seedlings = setEBV(seedlings, gs)
  ST1 = setEBV(ST1, gs)
  
 
  cat("  -> Update Parents\n")
  # source("4-1_UpdateParents_GSseed_cloneBreed.R")   replaced by genetic algorithm
  
  # All seedlings are poptential new parents. However, since the GA would be overchallenged with about 11,000 individuals,
  # a within-family preselection of the 10 best individuals is upstream (highest EBV)
  # The actual crosses will be generated downstream
  # parents <- selectWithinFam(seedlings, 21, use ="ebv") 

  
  cat("  -> Calculate Population Parameters\n")
  popParSeed <- genParam(seedlings)
  popParSt1 <- genParam(ST1)
  popParSt5 <- genParam(ST5)
  
  source("CB_PopulationParametersDom_GSseed.R")
  
  fxEff <- b
  cat("  -> Advance Year\n")
  source("4-2_AdvanceYear_GSseed_cloneBreed.R")
  
  cat("  -> Create Crossing Plan\n")
  # Identify the next generation's parents and their cross combinations
  # selectCrossPlan(cylce, number of Crosses, SNP genotypes of individuals, additive effects oestimated with the GS model, dominance effects)
  
  ## 1st cycle
  plan = selectCrossPlan(b,nCrosses,pullSnpGeno(parents), 
                         gs@gv[[1]]@addEff, targAngle,
                         pullQtlGeno(parents),SP$traits[[1]]@addEff)
  
  f1Acc[c,1] <- plan$PredAcc
  seedlings = makeCrossMultProgeny(parents, plan$crossPlan, nProgeny=nFamLines) 
  parents = seedlings
  
  ## 2nd cycle
  plan = selectCrossPlan(b,nCrosses,pullSnpGeno(parents), 
                         gs@gv[[1]]@addEff, targAngle,
                         pullQtlGeno(parents),SP$traits[[1]]@addEff)
  
  f1Acc[c,2] <- plan$PredAcc                       
  seedlings = makeCrossMultProgeny(parents, plan$crossPlan, nProgeny=nFamLines) 
  parents = seedlings
  
  ## 3rd cycle
  plan = selectCrossPlan(b,nCrosses,pullSnpGeno(parents), 
                         gs@gv[[1]]@addEff, targAngle,
                         pullQtlGeno(parents),SP$traits[[1]]@addEff)
  
  f1Acc[c,3] <- plan$PredAcc
  seedlings = makeCrossMultProgeny(parents, plan$crossPlan, nProgeny=nFamLines) 
  seedlings = setPheno(seedlings, varE=eVarSeed, reps=1, p=w, fixEff=fxEff)
  
  
  cat("  -> Train Prediction Model\n")
  
  if(c==1){
    trainPop <- c(trainPop, ST1, ST2, ST3, ST4)
  } else {
    trainPop <- c(trainPop, ST1, ST2, ST3, ST4, ST5)  # year 2 is first year of genotyped ST1s from burn-in to be in ST5
  }
  
}

### CALCULATE THE POPULATION PARAMETERS FOR THE FINAL POP

b = b+1

gs = RRBLUP(trainPop)

seedlings = setEBV(seedlings, gs)
ST1 = setEBV(ST1, gs)

cat("  -> Calculate Population Parameters\n")
popParSeed <- genParam(seedlings)
popParSt1 <- genParam(ST1)
popParSt5 <- genParam(ST5)

source("CB_PopulationParametersDom_GSseed.R")

fxEff <- b
source("4-2_AdvanceYear_GSseed_cloneBreed.R")
plan = selectCrossPlan(b,nCrosses,pullSnpGeno(parents), 
                       gs@gv[[1]]@addEff, targAngle,
                       pullQtlGeno(parents),SP$traits[[1]]@addEff)

f1Acc[c+1,1] <- plan$PredAcc

seedOutput$scenario = st1Output$scenario = st5Output$scenario = "SeedGS3-OCS0"

output = list(rbind(seedOutput, st1Output, st5Output))
output[[2]] <- f1Acc

saveRDS(output,paste0("Results_",JOB,"_",domDegree,".rds"))
