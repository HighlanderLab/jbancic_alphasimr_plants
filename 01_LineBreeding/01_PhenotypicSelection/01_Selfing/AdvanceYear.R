#-----------------------------------------------------------------------
# Advance year
#-----------------------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

##Year 10
##Release variety

##Year 9
EYT = selectInd(AYT, nEYT)
EYT = setPheno(EYT, h2 = h2, reps = repEYT)

#Year 8
AYT = selectInd(PYT, nAYT)
AYT = setPheno(AYT, h2 = h2, reps = repAYT)

#Year 7
PYT = selectInd(F6, nPYT)
PYT = setPheno(PYT, h2 = h2, reps = repPYT)

##Year 6
F6 = vector("list",nCrosses) #Selected plants from each cross
for(i in 1:nCrosses){ #Loop over crosses
  n = nInd(F5[[i]]) #Number of rows per cross
  F6lines = vector("list",n) #Rows in crosses
  F6pheno = numeric(n) #Row phenotypes
  for(j in 1:n){
    F6lines[[j]] = F5[[i]][j] #No selfing due to deriving lines
    F6_j = self(F5[[i]][j],plantsPerRow)
    F6pheno[j] = meanP(F6_j)
  }
  ## Select "nF6_row" F6 rows per cross
  take = order(F6pheno,decreasing=TRUE)[1:nF6_row]
  F6lines = F6lines[take]
  ## Derive new lines from rows
  F6[[i]] = mergePops(F6lines)
}
F6 = mergePops(F6)
F6 = setPheno(F6, h2=h2, reps = repF6)

##Year 5
## Grow selected plants in F5 rows
F5 = vector("list",nCrosses) #Selected plants from each cross
for(i in 1:nCrosses){ #Loop over crosses
  n = nInd(F4[[i]]) #Number of rows per cross
  F5rows = vector("list",n) #Rows in crosses
  F5pheno = numeric(n) #Row phenotypes
  for(j in 1:n){
    F5rows[[j]] = self(F4[[i]][j],plantsPerRow)
    F5pheno[j] = meanP(F5rows[[j]])
  }
  ## Select "nF5_row" F5 rows per cross
  take = order(F5pheno,decreasing=TRUE)[1:nF5_row]
  F5rows = F5rows[take]
  ## Select "nF5_ind" plants per F5 row
  for(j in 1:nF5_row){
    F5rows[[j]] = selectInd(F5rows[[j]],nF5_ind)
  }
  F5[[i]] = mergePops(F5rows)
}

##Year 4
## Grow selected plants in F4 rows
F4 = vector("list",nCrosses) #Selected plants from each cross
for(i in 1:nCrosses){ #Loop over crosses
  n = nInd(F3[[i]]) #Number of rows per cross
  F4rows = vector("list",n) #Rows in crosses
  F4pheno = numeric(n) #Row phenotypes
  for(j in 1:n){
    F4rows[[j]] = self(F3[[i]][j],plantsPerRow)
    F4pheno[j] = meanP(F4rows[[j]])
  }
  ## Select "nF4_row" F4 rows per cross
  take = order(F4pheno,decreasing=TRUE)[1:nF4_row]
  F4rows = F4rows[take]
  ## Select "nF4_ind" plants per F4 row
  for(j in 1:nF4_row){
    F4rows[[j]] = selectInd(F4rows[[j]],nF4_ind)
  }
  F4[[i]] = mergePops(F4rows)
}

##Year 3
F3 = vector("list",nCrosses) #Selected plants from each cross
for(i in 1:nCrosses){ #Loop over crosses
  n = nInd(F2[[i]]) #Number of rows per cross
  F3rows = vector("list",n) #Rows in crosses
  F3pheno = numeric(n) #Row phenotypes
  for(j in 1:n){
    F3rows[[j]] = self(F2[[i]][j],plantsPerRow)
    F3pheno[j] = meanP(F3rows[[j]])
  }
  ## Select "nF3_row" F3 rows per cross
  take = order(F3pheno,decreasing=TRUE)[1:nF3_row]
  F3rows = F3rows[take]
  ## Select "nF3_ind" plants per selected F3 row
  for(j in 1:nF3_row){
    F3rows[[j]] = selectInd(F3rows[[j]],nF3_ind)
  }
  F3[[i]] = mergePops(F3rows)
}

##Year 2
F2 = vector("list",nCrosses) #Keep crosses seperate
for(i in 1:nCrosses){ #Loop over crosses
  F2_i = self(F1[i], nProgeny = nF2)
  F2[[i]] = selectInd(F2_i, nInd = nF2_ind)
}

##Year 1
F1 = randCross(Parents, nCrosses)
