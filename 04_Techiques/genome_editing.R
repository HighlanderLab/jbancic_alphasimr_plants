rm(list = ls())

##-- Load packages
require("AlphaSimR")


#Generate founder haplotypes -

founderPop = runMacs(nInd     = 100,
                     segSites = 1000,
                     inbred   = TRUE,
                     species  = "WHEAT")

SP = SimParam$new(founderPop)

SP$addTraitAG(nQtlPerChr = 1000,
              mean       = 0 ,
              var        = 1)

Parents = newPop(founderPop)
gv(Parents)[1]

genMap  = pullQtlHaplo(Parents)

##Edit the first 100 QTL on the first homologue to be the 1 allele
for(i in 1:100){
  genMap[paste0(i,"_1"),"1_1"] <- 1
}

#To change a single locus instead you could do the following which
#changes position 5 on the first homologue in individual 1 to its
#alternative allele
## genMap[c("5_1"),1] <- (genMap[c("5_1"),1] + 1)%%2

Parents <- setMarkerHaplo(Parents, genMap)
gv(Parents)[1]
