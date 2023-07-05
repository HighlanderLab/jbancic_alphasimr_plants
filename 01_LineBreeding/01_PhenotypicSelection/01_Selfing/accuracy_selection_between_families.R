accuracy_family <- function(stage){
  mother <- stage@mother
  father <- stage@father
  df <- data.frame(
    mother = mother,
    father = father
  )
  df <- unique(df)
  families <- vector(mode = "list", length = nrow(df))
  for (i in 1:nrow(df)) {
    mother_i <- df$mother[i]
    father_i <- df$father[i]
    families_i <- stage@mother == mother_i & stage@father == father_i
    tmp <- stage[families_i]
    families[[i]] <- tmp
    ##PG: Do we want group level heritability so there is measurment
    ##error?
  }
  phenotypes <- unlist(lapply(families, meanP))
  gvs <- unlist(lapply(families,meanG))
  ##PG: sometimes the gvs are all identical throwing an NA for the correlatioon.
  cor(gvs,phenotypes)
}
