#!/exports/cmvm/eddie/eb/groups/tier2_hickey_group/Programs/R-4.0.0/bin/Rscript
#$ -cwd
#$ -R y
#$ -pe sharedmem 8
#$ -l h_vmem=32G
#$ -l h_rt=20:00:00
#$ -j y
#$ -V
#$ -m ea
#$ -M christian.werner@roslin.ed.ac.uk 
#$ -l h='!node1f01.ecdf.ed.ac.uk&!node1f02.ecdf.ed.ac.uk'


library(AlphaSimR)
# 
#domDegree <- "01"
#domDeg <- 0.1
#JOB = 5

#### AUTO-DEFINE SIMULATION PARAMETERS HERIT AND DOMDEG BASED ON WORKING DIRECTORY

specs <- getwd()
domDegree <- gsub(".*domDeg_","", specs)
rm(specs)
JOB = Sys.getenv("SGE_TASK_ID")

load(paste0("CbBURNIN-",JOB,"_",domDegree,".RData"))
REP = JOB
JOB = paste0("ST1GS", JOB)



nFamLines = nFamLinesGS  # REDUCE NUMBER OF INDIVIDUALS PER CROSS

cat(paste0("\n","GS in Stage 1","\n"))


for(c in 1:cycles){ 
  w=wEff[c]
  b=brnIn+c
  cat(paste0("cycle",b,"\n"))
  
  
  cat("  -> Calculate EBVs and EGVs\n")
  gs = RRBLUP(pop=trainPop)     
  
  if (c==1){parents = setEBV(parents, gs)}
  ST1 = setEBV(ST1, gs)
  
  cat("  -> Update Parents\n")
  source("3-1_UpdateParents_Gs_cloneBreed.R")

  
  cat("  -> Calculate Population Parameters\n")   
  popParSeed <- genParam(seedlings)
  popParSt1 <- genParam(ST1)
  popParSt5 <- genParam(ST5)
  
  source("CB_PopulationParametersDom_GS.R")      # calculation of EGV for ST1 within script

  
  fxEff <- b
  cat("  -> Advance Year\n")
  source("3-2_AdvanceYear_Gs_cloneBreed.R")
  
  # New seedlings - after Advance Year to use same script 3_2 for normal ST1-GS and ST-GS-OCS
  seedlings = randCross(parents, nCrosses = nCrosses, nProgeny = nFamLines)
  seedlings = setPheno(seedlings, varE=eVarSeed, reps=1, p=w, fixEff=fxEff)
  

  cat("  -> Train Prediction Model\n")
  
  if(c==1){
    trainPop <- c(trainPop, ST1, ST2, ST3, ST4)
  } else {
    trainPop <- c(trainPop, ST1, ST2, ST3, ST4, ST5)  # year 2 is first year of genotyped ST1s from burn-in to be in ST5
  }
  

}


### CALCULATE THE POPULATION PARAMETERS FOR THE FINAL POP

b <- b+1
gs <- RRBLUP(trainPop)     

ST1 <- setEBV(ST1, gs)

cat("  -> Calculate Population Parameters\n")
popParSeed <- genParam(seedlings)
popParSt1 <- genParam(ST1)
popParSt5 <- genParam(ST5)
source("CB_PopulationParametersDom_GS.R")   # calculation of EGV for ST1 within script

seedOutput$scenario = st1Output$scenario = st5Output$scenario ="ST1GS"

output = rbind(seedOutput, st1Output, st5Output)

saveRDS(output,paste0("Results_",JOB,"_",domDegree,".rds"))

#plot(x=output$cycle[1:41], y=output$gain[1:41], type="l")
#plot(x=output$cycle[42:82], y=output$gain[42:82], type="l")
