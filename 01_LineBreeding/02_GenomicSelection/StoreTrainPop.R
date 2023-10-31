#-----------------------------------------------------------------------
# Store training population of the past 3 years
#-----------------------------------------------------------------------

if (year == 16){
  cat("  Start collecting training population \n")
  TrainPop = c(EYT,AYT) ##PG These in training?
}
if (year > 16 & year < 21){
  cat("  Collecting training population \n")
  TrainPop = c(TrainPop,
                   EYT,AYT) ##PG These in training?
}
if (year > 20){
  cat("  Maintaining training population \n")
  TrainPop = c(TrainPop[-c(1:c(EYT,AYT)@nInd)],
                   EYT,AYT) ##PG These in training?
}
