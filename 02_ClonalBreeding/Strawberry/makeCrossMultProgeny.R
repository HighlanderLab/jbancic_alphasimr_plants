
### Make multiple progeny per crossing according to a crossing plan

makeCrossMultProgeny <- function(pop, crossPlan, nProgeny=2, id = NULL, rawPop = FALSE, simParam = NULL) 
{
  if (is.null(simParam)) {
    simParam = get("SP", envir = .GlobalEnv)
  }
  if (pop@ploidy != 2) {
    stop("Only works with diploids")
  }
  
  if (nProgeny > 1) {
    crossPlan = cbind(rep(crossPlan[, 1], each = nProgeny), 
                      rep(crossPlan[, 2], each = nProgeny))
  }
  return(makeCross(pop = pop, crossPlan = crossPlan, simParam = simParam))

}
