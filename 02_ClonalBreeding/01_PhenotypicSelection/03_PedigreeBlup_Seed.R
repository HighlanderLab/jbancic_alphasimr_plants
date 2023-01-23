#!/exports/cmvm/eddie/eb/groups/HighlanderLab/communal/R-4.1.3/R-4.1.3/bin/Rscript
#$ -N Ped_Sd
#$ -cwd
#$ -R y
#$ -pe sharedmem 4
#$ -l h_vmem=4G
#$ -l h_rt=20:00:00
#$ -j y
#$ -V
#$ -P roslin_HighlanderLab
#$ -M jbancic@exseed.ed.ac.uk

rm(list = ls())
library(AlphaSimR)
library(asreml)
nReps = 30    # Number of simulation replications

# Loop over replicates
for(REP in 1:nReps){
  cat("Working on REP:", REP,"\n") 
  # Load data
  load(paste0("BURNIN_", REP, ".RData"))
  
  # Set alternative scenario name
  scenarioName = "PedigreeBlup_Seed"
  
  # Change scenario
  output$scenario = scenarioName
  
  # Run 20 cycle of breeding program
  for(year in (nBurnIn + 1):nCycles){ 
    cat(" Working on year ", year, "\n", sep = "")
    
    # Use pedigree prediction to select new parents
    source("PredigreeModel.R")
    Seedlings@ebv = as.matrix(tail(EBV, Seedlings@nInd))
    Parents = selectInd(Seedlings, nInd = 20, use = "ebv")
    
    # Year 13
    ECT6 = setPheno(ECT5,varE = VarE, reps = repECT, p = P[year])
    
    # Year 12
    ECT5 = ECT4
    
    # Year 11
    ECT4 = ECT3
    
    # Year 10
    ECT3 = ECT2
    
    # Year 9
    ECT2 = ECT1
    
    # Year 8
    output$accACT[year] = cor(gv(ACT5), pheno(ACT5)) # accuracy based on 500 inds
    ECT1 = selectInd(ACT5, nInd = nClonesPhenoECT, use = "pheno")
    
    # Year 7
    ACT5 = setPheno(ACT4,varE = VarE, reps = repACT, p = P[year])
    
    # Year 6
    ACT4 = ACT3
    
    # Year 5
    ACT3 = ACT2
    
    # Year 4
    ACT2 = ACT1
    
    # Year 3 - use pedigree selection on seedlings
    output$accSeed[year] = cor(gv(Seedlings), ebv(Seedlings)) # accuracy based on 2000 inds
    ACT1 = selectInd(Seedlings, nInd = nClonesPhenoACT, use = "ebv")
    
    # Year 2
    Seedlings = setPheno(F1,varE = VarE, reps = repHPT, p = P[year])
    
    # Year 1
    # Crossing block
    F1 = randCross(Parents, nCrosses=ncross, nProgeny = nProgPheno)
    
    # Update pedigree
    ped = rbind(ped,
                data.frame(Ind = c(ACT5@id),
                           Sire = c(ACT5@father),
                           Dam = c(ACT5@mother),
                           Year = year,
                           Stage = c(rep("ACT",ACT5@nInd)),
                           Pheno = c(ACT5@pheno)))
    
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
  
  ## Save output
  cat(paste0("saving REP ", REP, "\n"))
  saveRDS(output, paste0(scenarioName, "_", REP, ".rds"))  
}
