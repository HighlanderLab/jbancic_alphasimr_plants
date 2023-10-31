#-----------------------------------------------------------------------
# Store training population of the past 3 years
#-----------------------------------------------------------------------

if (year == startTP){
  cat("  Start collecting training population \n")
  TrainPop = c(EYT,AYT) ##PG These in training?
}
if (year > startTP & year < nBurnin+1){
  cat("  Collecting training population \n")
  TrainPop = c(TrainPop,
                   EYT,AYT) ##PG These in training?
}
if (year > nBurnin){
  cat("  Maintaining training population \n")
  TrainPop = c(TrainPop[-c(1:c(EYT,AYT)@nInd)],
                   EYT,AYT) ##PG These in training?
}
