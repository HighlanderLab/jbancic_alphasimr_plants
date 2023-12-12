#-----------------------------------------------------------------------
# Save pedigree records and training population for GS from year 35
#-----------------------------------------------------------------------

if (year == startTP){
  cat("  Start collecting training population \n")
  TrainPop = c(ST1, ST2, ST3, ST4)
}
if (year > startTP & year < nBurnin+1){
  cat("  Collecting training population \n")
  TrainPop = c(TrainPop,
               ST1, ST2, ST3, ST4)
}
if (year > nBurnin){
  cat("  Maintaining training population \n")
  TrainPop = c(TrainPop[-c(1:c(ST1, ST2, ST3, ST4)@nInd)],
               ST1, ST2, ST3, ST4)
}
