# This script shows examples how different mating designs 
# can be specified in AlphaSimR. 

##-- Load packages
rm(list = ls())
require("AlphaSimR")

##-- Create founder haplotypes
founderPop = runMacs(nInd     = 100,
                     segSites = 1000,
                     inbred   = TRUE,
                     species  = "WHEAT")
# Set simulation parameters
SP = SimParam$new(founderPop)

# Add trait with dominance
SP$addTraitAD(nQtlPerChr = 1000,
              mean   = 5,
              var    = 1,
              meanDD = 0.92,
              varDD  = 0.2)

# Create a single population
pop = newPop(founderPop)
pop = setPheno(pop,h2 = 0.5)
# Create two populations and testers
popA = pop[1:10]
popB = pop[11:20]
testerA = popA[1:2]
testerB = popB[1:2]



## Crosses within a single population
######################################################################
##-- Random biparental/paired cross
newPop = randCross(pop, nCrosses = 10, nProgeny = 100)
table(newPop@father, newPop@mother) # visualise
# Compare genetic mean and variance
meanG(pop); meanG(newPop)
varG(pop); varG(newPop)


##-- Full diallel with reciprocal crosses and selfs (n x n)
crossPlan = expand.grid(1:nInd(popA), 1:nInd(popA))
newPop = makeCross2(popA, popA, crossPlan, nProgeny = 10)
table(newPop@father, newPop@mother) # visualise
# Compare genetic mean and variance
meanG(pop); meanG(newPop)
varG(pop); varG(newPop)


##-- Half diallel without reciprocal crosses and selfs (n(n-1)/2)
crossPlan = expand.grid(1:5, 6:10)
newPop = makeCross2(popA, popA, crossPlan, nProgeny = 40)
table(newPop@father, newPop@mother) # visualise
# Compare genetic mean and variance
meanG(pop); meanG(newPop)
varG(pop); varG(newPop)


##-- Specified crosses
crossPlan = cbind(1, 2:20)
newPop = makeCross(pop, crossPlan, nProgeny = 50)
table(newPop@father, newPop@mother) # visualise
# Compare genetic mean and variance
meanG(pop); meanG(newPop)
varG(pop); varG(newPop)


##-- Specified crosses with maximum avoidance
maxAvoidPlan = function(nInd, nProgeny=1L){
  crossPlan = matrix(1:nInd, ncol=2, byrow=TRUE)
  tmp = c(seq(1, nInd, by=2),
          seq(2, nInd, by=2))
  crossPlan = cbind(rep(tmp[crossPlan[,1]], 
                        each=nProgeny),
                    rep(tmp[crossPlan[,2]], 
                        each=nProgeny))
  return(crossPlan)
}
crossPlan = maxAvoidPlan(nInd = 20, nProgeny = 100)
newPop = makeCross(pop, crossPlan)
table(newPop@father, newPop@mother) # visualise
# Compare genetic mean and variance
meanG(pop); meanG(newPop)
varG(pop); varG(newPop)


##-- Develop Multiparent Generation Intercross (MAGIC) population
newPop <- pop[1:8]
# 2-way crosses
crossPlan = cbind(c(1,3,5,7),
                  c(2,4,6,8))
newPop = makeCross(pop, crossPlan)
table(newPop@father, newPop@mother) # visualise
# 4-way crosses
crossPlan = cbind(c(1,3),
                  c(2,4))
newPop = makeCross(newPop, crossPlan)
table(newPop@father, newPop@mother) # visualise
# 8-way crosses
crossPlan = cbind(1,2)
newPop = makeCross(newPop, crossPlan, nProgeny = 1000)
table(newPop@father, newPop@mother) # visualise
# Create inbred lines from the final cross
for(i in 1:6){
  newPop = self(newPop, nProgeny = 1)
}
# Check inbreeding
1-mean(rowMeans(1-abs(pullQtlGeno(pop)-1)))
# Compare genetic mean and variance
meanG(pop[1:8]); meanG(newPop)
varG(pop[1:8]); varG(newPop)



## Crosses among two populations
######################################################################
# Function to calculate heterosis
calcHeterosis <- function(popA, popB, hybPop) {
  inbMean = (meanG(popA) + meanG(popB))/2
  hybMean = meanG(hybPop)
  heterosis = meanG(hybPop) - (meanG(popA) + meanG(popB))/2
  perHeterosis = (hybMean-inbMean)/inbMean*100
  return(data.frame("Midparent value" = inbMean,
                    "Hybrid value" = hybMean,
                    "Heterosis" = heterosis,
                    "Percent heterosis" = perHeterosis))
}


##-- Testcross/Topcross/North Carolina 1 
crossPlan = expand.grid(1:nInd(popA), 1:nInd(testerB))
newPop = makeCross2(popA, popB, crossPlan, nProgeny = 1)
table(newPop@father, newPop@mother) # visualise
# Using internal AlphaSimR function
newPop = hybridCross(females = popA, males =  testerB)
table(newPop@father, newPop@mother) # visualise
# Check heterosis
calcHeterosis(popA,popB,newPop)


##-- Factorial/North Carolina 2 (half diallel)
crossPlan = expand.grid(1:nInd(popA), 1:nInd(popB))
# with(crossPlan, table(Var1,Var2))
newPop = makeCross2(popA, popB, crossPlan, nProgeny = 1)
table(newPop@father, newPop@mother) # visualise
# Check heterosis
calcHeterosis(popA,popB,newPop)


##-- Specified full diallel between two populations
crossPlan = expand.grid(1:nInd(popA), 1:nInd(popB))
with(crossPlan, table(Var1,Var2))
newPop1 = makeCross2(popA, popA, crossPlan, nProgeny = 1)
newPop2 = makeCross2(popB, popB, crossPlan, nProgeny = 1)
newPop = c(newPop1,newPop2)
table(newPop@father, newPop@mother) # visualise
# Check heterosis
calcHeterosis(popA,popB,newPop)
