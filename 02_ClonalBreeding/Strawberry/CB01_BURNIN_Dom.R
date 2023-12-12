#!/exports/cmvm/eddie/eb/groups/tier2_hickey_group/Programs/R-4.0.0/bin/Rscript
#$ -cwd
#$ -R y
#$ -pe sharedmem 4
#$ -l h_vmem=4G
#$ -l h_rt=00:40:00
#$ -j y
#$ -V
#$ -m ea
#$ -M christian.werner@roslin.ed.ac.uk 
#$ -l h='!node1f01.ecdf.ed.ac.uk&!node1f02.ecdf.ed.ac.uk'



### 1. LOAD PACKAGES AND FUNCTIONS

library(AlphaSimR)



### 2. DEFINE DOMINANCE DEGREE BASED ON WD

# domDegree <- 0
# domDeg <- 0.0
# JOB = 1

specs <- getwd()
domDegree <- gsub(".*domDeg_","", specs)
domDeg <- as.numeric(domDegree)/10        # used in CreateParents
rm(specs)

source("0_GlobalParameters_cloneBreedDom.R")

JOB = Sys.getenv("SGE_TASK_ID")


source("1_CreateParents_cloneBreedDom.R") 
parents = founderpop

source("1_FillPipeline_cloneBreed.R")



### CREATE OUTPUT MATRICES

seedOutput <- data.frame(matrix(NA, nrow=brnIn+cycles+1, ncol=10))
colnames(seedOutput) =c("cycle","scenario","stage", "gain", "meanA","meanG", "varG","h2", "rEBV", "Fcoeff")
seedOutput$stage = "SEED"

st1Output <- data.frame(matrix(NA, nrow=brnIn+cycles+1, ncol=10))
colnames(st1Output) =c("cycle","scenario","stage", "gain", "meanA","meanG", "varG","h2", "rEBV", "Fcoeff")
st1Output$stage = "ST1"

#st2Output <- data.frame(matrix(NA, nrow=brnIn+cycles+1, ncol=10))
#colnames(st2Output) =c("cycle","scenario","stage", "gain", "meanA","meanG", "varG","h2", "rEBV", "Fcoeff")
#st2Output$stage = "ST2"

st5Output <- data.frame(matrix(NA, nrow=brnIn+cycles+1, ncol=10))
colnames(st5Output) =c("cycle","scenario","stage", "gain", "meanA","meanG", "varG","h2", "rEBV", "Fcoeff")
st5Output$stage = "ST5"



### MEASURE INITIAL PARAMETERS OF THE CREATED BREEDING PROGRAM STAGES

### SEEDLINGS, ST1, ST2 AND ST5

# Calculate initial genomic heterozygosity of the population

seedHet = pullQtlGeno(seedlings)
seedHet0 = mean(rowMeans(1-abs(seedHet-1)))

st1Het = pullQtlGeno(ST1)
st1Het0 = mean(rowMeans(1-abs(st1Het-1)))

#st2Het = pullQtlGeno(ST2)
#st2Het0 = mean(rowMeans(1-abs(st2Het-1)))

st5Het = pullQtlGeno(ST5)
st5Het0 = mean(rowMeans(1-abs(st5Het-1)))


# empty TP to fill in later stages
trainPop <- vector()

#### BURN IN START ########################


cat(paste0("\n","Burn In","\n"))

for(b in 1:brnIn){
  
  cat(paste0("cycle",b,"\n"))
  w = runif(1)

  cat("  -> Calculate Population Parameters\n")
  popParSeed <- genParam(seedlings)
  popParSt1 <- genParam(ST1)
  popParSt5 <- genParam(ST5)
  
  source("CB_PopulationParameters.R")
  
  
  cat("  -> Update Parents\n")
  source("2-1_UpdateParents_cloneBreed.R")
 

  fxEff <- b                     # fixed effect for year
  cat("  -> Advance Year\n")
  source("2-2_AdvanceYear_cloneBreed.R")
  
  
  # TP populated over last 3 burn-in years (18-20)
  
  if(b>(brnIn-3)){
    cat("  -> Train Prediction Model\n")
    trainPop <- c(trainPop, ST1)
  }
  if(b>(brnIn-2)){
    trainPop <- c(trainPop, ST2)
  }
  if(b>(brnIn-1)){
    trainPop <- c(trainPop, ST3)
  }
  


}

trainPop <- mergePops(trainPop)
wEff <- runif(cycles)

save.image(paste0("CbBURNIN-",JOB,"_",domDegree,".RData"))

#plot(st1Output$cycle, st1Output$gain, type = "l")
