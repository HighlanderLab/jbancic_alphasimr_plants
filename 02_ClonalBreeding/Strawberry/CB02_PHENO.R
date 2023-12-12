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


library(AlphaSimR)

# domDegree <- 6
# domDeg <- 0.6
# JOB <- 1


#### AUTO-DEFINE SIMULATION PARAMETERS HERIT AND DOMDEG BASED ON WORKING DIRECTORY

specs <- getwd()
domDegree <- gsub(".*domDeg_","", specs)
rm(specs)
JOB = Sys.getenv("SGE_TASK_ID")


load(paste0("CbBURNIN-",JOB,"_",domDegree,".RData"))
REP = JOB
JOB = paste0("Pheno", JOB)


######################### BASELINE SCENARIO ###################################


cat(paste0("\n","Phenotypic Selection","\n"))

for(c in 1:cycles){
  
  b=brnIn+c
  w=wEff[c]

  cat(paste0("cycle",b,"\n"))
  

  cat("  -> Calculate Population Parameters\n")
  popParSeed <- genParam(seedlings)
  popParSt1 <- genParam(ST1)
  popParSt5 <- genParam(ST5)
  
  source("CB_PopulationParameters.R")

  cat("  -> Update Parents\n")   
  source("2-1_UpdateParents_cloneBreed.R")


  fxEff <-  b
  cat("  -> Advance Year\n")
  source("2-2_AdvanceYear_cloneBreed.R")
  
}


### CALCULATE THE POPULATION PARAMETERS FOR THE FINAL POP

b = b+1

cat("  -> Calculate Population Parameters\n")
popParSeed <- genParam(seedlings)
popParSt1 <- genParam(ST1)
popParSt5 <- genParam(ST5)
source("CB_PopulationParameters.R")

seedOutput$scenario = st1Output$scenario  = st5Output$scenario = "Pheno"

output = rbind(seedOutput, st1Output, st5Output)

saveRDS(output,paste0("Results_",JOB,"_",domDegree,".rds"))

#plot(x=output$cycle[1:41], y=output$gain[1:41], type="l")
#plot(x=output$cycle[42:82], y=output$gain[42:82], type="l")
