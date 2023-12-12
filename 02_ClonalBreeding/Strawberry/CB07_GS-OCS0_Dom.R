#!/exports/cmvm/eddie/eb/groups/tier2_hickey_group/Programs/R-4.0.0/bin/Rscript
#$ -cwd
#$ -R y
#$ -pe sharedmem 8
#$ -l h_vmem=8G
#$ -l h_rt=20:00:00
#$ -j y
#$ -V
#$ -m ea
#$ -M christian.werner@roslin.ed.ac.uk 
#$ -l h='!node1f01.ecdf.ed.ac.uk&!node1f02.ecdf.ed.ac.uk'


library(AlphaSimR)
Rcpp::sourceCpp("AddCrossing_wLogfile_corr.cpp")
source("makeCrossMultProgeny.R")

ocsDegree = 0
# domDegree <- "00"
# domDeg <- 0.0
# JOB = 1

#### AUTO-DEFINE SIMULATION PARAMETERS HERIT AND DOMDEG BASED ON WORKING DIRECTORY

specs <- getwd()
domDegree <- gsub(".*domDeg_","", specs)
rm(specs)
JOB = Sys.getenv("SGE_TASK_ID")

load(paste0("CbBURNIN-",JOB,"_",domDegree,".RData"))
REP = JOB
JOB = paste0("GS-OCS0_", JOB)



nFamLines = nFamLinesGS  # REDUCE NUMBER OF INDIVIDUALS PER CROSS
targAngle <- ocsDegree*pi/180 # OCS angle in rad

cat(paste0("\n","GS in Stage 1","\n"))

f1Acc <- matrix(NA,nrow=cycles+1, ncol=1)


for(c in 1:cycles){ 
  w=wEff[c]
  b=brnIn+c
  cat(paste0("cycle",b,"\n"))
  
  
  cat("  -> Calculate EBVs and EGVs\n")
  
  gs = RRBLUP(pop=trainPop)     
  
  if (c==1){parents = setEBV(parents, gs)}
  ST1 = setEBV(ST1, gs)
  
  cat("  -> Update Parents\n")
  # source("3-1_UpdateParents_Gs_cloneBreed.R") is replaced by the genetic algorithm that finds the optimal cross combinations among all ST1s
  
  if(c==1){
    parents <- c(parents, ST1)
  } else {
      parents <- ST1
    }
  
  
  cat("  -> Calculate Population Parameters\n")
  popParSeed <- genParam(seedlings)
  popParSt1 <- genParam(ST1)
  popParSt5 <- genParam(ST5)
  
  source("CB_PopulationParametersDom_GS.R")

  
  fxEff <- b
  cat("  -> Advance Year\n")
  source("3-2_AdvanceYear_Gs_cloneBreed.R")

  cat("  -> Create Crossing Plan\n")
  # Identify the next generation's parents and their cross combinations
  # selectCrossPlan(cylce, number of Crosses, SNP genotypes of individuals, additive effects oestimated with the GS model, dominance effects)
  plan = selectCrossPlan(b,nCrosses,pullSnpGeno(parents), 
                         gs@gv[[1]]@addEff, targAngle,
                         pullQtlGeno(parents),SP$traits[[1]]@addEff)
  
  f1Acc[c] <- plan$PredAcc
  
  
  ### WRITE GA OUTPUT
  
  # 1. Write Crossing Plans in one file
  # if(c==1){
  #   crsPln <- data.frame(plan$crossPlan)
  #   colnames(crsPln) <- c("P1", "P2")
  # }
  # 
  # if(c>1){
  #   planTmp <- data.frame(plan$crossPlan)
  #   colnames(planTmp) <- c("P1", "P2")
  #   crsPln <- cbind(crsPln, planTmp)
  #   rm(planTmp)
  # }
  
  # 2. GA Parameter File 
  if(ocsDegree < 1e-7){
    outputGA <- data.frame(round(plan$uMax,3), round(plan$simMax,3))
    
    if(c==1){
      colnames(outputGA) <- c("uMax", "simMax")
      write.table(outputGA, paste0("outputGA_deg", ocsDegree,"_rep",REP, ".txt"), quote =FALSE, row.names = FALSE, col.names = TRUE)
    }
  }else{
    outputGA <- data.frame(round(plan$uMax,3), round(plan$uMin,3), round(plan$simMax,3), round(plan$simMin,3), 
                           round(plan$uBest,3), round(plan$simBest,3),round(plan$angleBest,3), round(plan$lenBest,3))
    
    if(c==1){
      colnames(outputGA) <- c("uMax", "uMin", "simMax", "simMin", "uBest", "simBest", "angleBest", "lenBest")
      write.table(outputGA, paste0("outputGA_deg", ocsDegree,"_rep",REP, ".txt"), quote =FALSE, row.names = FALSE, col.names = TRUE)
    }
  }
  
  if(c>1){
    write.table(outputGA, paste0("outputGA_deg", ocsDegree,"_rep",REP, ".txt"), quote =FALSE, row.names = FALSE, col.names = FALSE, append=TRUE)
  }
  
  
  
  cat("  -> Create Seedlings\n")
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

#write.table(crsPln, "crossingPlans.txt", quote =FALSE, row.names = FALSE, col.names = TRUE)

b =b+1
gs = RRBLUP(trainPop)     

ST1 = setEBV(ST1, gs)

cat("  -> Calculate Population Parameters\n")
popParSeed <- genParam(seedlings)
popParSt1 <- genParam(ST1)
popParSt5 <- genParam(ST5)
source("CB_PopulationParametersDom_GS.R")   # calculation of EGV for ST1 within script

fxEff <- b
source("3-2_AdvanceYear_Gs_cloneBreed.R")
plan = selectCrossPlan(b,nCrosses,pullSnpGeno(parents), 
                       gs@gv[[1]]@addEff, targAngle,
                       pullQtlGeno(parents),SP$traits[[1]]@addEff)

f1Acc[c+1] <- plan$PredAcc

seedOutput$scenario = st1Output$scenario = st5Output$scenario = "GS-OCS0"

output = list(rbind(seedOutput, st1Output, st5Output))
output[[2]] <- f1Acc

saveRDS(output,paste0("Results_",JOB,"_",domDegree,".rds"))

# plot(x=output$cycle[1:41], y=output$gain[1:41], type="l")
# plot(x=output$cycle[42:82], y=output$gain[42:82], type="l")
