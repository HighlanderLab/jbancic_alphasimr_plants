# This script simulations a bulk selection strategy
# to produce F4-derived Lines

library(AlphaSimR)
# Global variables
# Can be changed, but watch out for fractional values
#   i.e. nPlantF3/nSelPlantF2 should be an integer
nChr = 10 #Number of Chromosomes
nQtl = 100 #Number of QTL per chromosome

genVar = 30 #Genetic variance
errVar = 70000 #Error variance for a plant, population error is errVar/nPlant

nParent = 50 #Number of parent lines

nCross = 600 #Number of crosses, equals number of F2 populations
nF3 = 300 #Number of F3 populations
nF4 = 200 #Number of F4 populations
nPopLine = 100 #Number of populations selected to form Lines

nPlantF1 = 10 #Number of plants in F1 population
nPlantF2 = 1000 #Number of plants in F2 population
nPlantF3 = 1000 #Number of plants in F3 population
nPlantF4 = 1000 #Number of plants in F4 population

nSelPlantF2 = 50 #Number of plants per selected F2 population
nSelPlantF3 = 50 #Number of plants per selected F3 population
nPlantLine = 10 #Number of plants per population to form Lines


pop = runMacs(nParent,nChr,nQtl)
SP = SimParam$new(pop)
SP$addTraitA(nQtl,mean=0,genVar)
SP$setVarE(varE=errVar)
parents = newPop(pop)

# Sample crosses
# Uses an internal AlphaSimR function without help documentation
crossPlan = AlphaSimR:::sampHalfDialComb(nParent,nCross)

# Create F1 populations
F1 = vector("list",nCross)
for(i in 1:nCross){
  F1[[i]] = makeCross(parents,
                      crossPlan=matrix(rep(crossPlan[i,],nPlantF1),
                                       ncol=2,byrow=TRUE))
}

F2 = lapply(F1,self,nProgeny=nPlantF2/nPlantF1) #Self to get F2 plants
F2pheno = unlist(lapply(F2,meanP)) #Calculate mean phenotype

F3 = F2[order(F2pheno,decreasing=TRUE)[1:nF3]] #Pick best by mean
F3 = lapply(F3,selectInd,nInd=nSelPlantF2) #Pick best plants within pops
F3 = lapply(F3,self,nProgeny=nPlantF3/nSelPlantF2) #Self to create F3
F3pheno = unlist(lapply(F3,meanP)) #Calculate mean phenotype

F4 = F3[order(F3pheno,decreasing=TRUE)[1:nF4]] #Pick best by mean
F4 = lapply(F4,selectInd,nInd=nSelPlantF3) #Pick best plants within pops
F4 = lapply(F4,self,nProgeny=nPlantF4/nSelPlantF3) #Self to create F4
F4pheno = unlist(lapply(F4,meanP)) #Calculate mean phenotype

Lines = F4[order(F4pheno,decreasing=TRUE)[1:nPopLine]] #Pick best by mean
Lines = lapply(Lines,selectInd,nInd=nPlantLine) #Pick best plants
Lines = mergePops(Lines)

#Mean and variance of Lines
meanG(Lines) #Initial mean is 0, so value reflect genetic gain
varG(Lines) #Initial value was genVar

#Best parent vs best Line
max(parents@gv)
max(Lines@gv)
