# This script demonstrates how to specify your own demographic history 
# Parameters are chosen hypothetically but would normally be obtained 
# from existing literature. 

##-- Load packages
rm(list = ls())
require("AlphaSimR")

#-- Example 1: Specify generic demographic history as in AlphaSimR
######################################################################
(manualCommand = runMacs2(nInd     = 100,
                          nChr     = 10,
                          segSites = 1000,
                          Ne       = 100,
                          bp       = 1e+08,
                          genLen   = 1,
                          mutRate  = 3e-08,
                          histNe   = c(500, 1500, 6000,  12e3, 1e5), 
                          histGen  = c(100, 1000, 10000, 1e5,  1e6),
                          # split    = 100, # specify time of population split 
                          ploidy   = 2L,
                          inbred   = T,
                          returnCommand = T))

#-- Create founder haplotypes with desired demography
founderPop = runMacs(nInd     = 100,
                     nChr     = 10,
                     segSites = 1000,
                     inbred   = TRUE,
                     manualGenLen  = 1,
                     manualCommand = manualCommand)
#-- Set simulation parameters
SP = SimParam$new(founderPop)

#-- Create founder population
pop = newPop(founderPop)



#-- Example 2: Specify demographic history of wheat as in AlphaSimR
######################################################################
(manualCommand = runMacs2(nInd     = 100,
                         nChr     = 10,
                         segSites = 1000,
                         Ne       = 50,
                         bp       = 8e+08,
                         genLen   = 1.43,
                         mutRate  = 2e-09,
                         histNe   = c(50,100,200,300,400,500,600,700,800,900,1e3,2e3,3e3,4e3,5e3,6e3,7e3,8e3,9e3,1e4,12e3,16e3,20e3,24e3,28e3,32e3), 
                         histGen  = c(5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100,200,400,600,800,1e3,2e3,4e3,6e3,8e3,10e3,20e3,40e3,60e3,80e3,10e4),
                         # split    = 100, # specify time of population split 
                         ploidy   = 2L,
                         inbred   = T,
                         returnCommand = T))

#-- Create founder haplotypes with desired demography
founderPop = runMacs(nInd     = 100,
                     nChr     = 10,
                     segSites = 1000,
                     inbred   = TRUE,
                     manualGenLen  = 1,
                     manualCommand = manualCommand)
#-- Set simulation parameters
SP = SimParam$new(founderPop)

#-- Create founder population
pop = newPop(founderPop)

