#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data
#w is created outside the script

#Year 7
#Release variety

#Year 6
ST5 = setPheno(ST4,varE=eVarSt1,reps=repS45, p=w)
ST5@pheno = (ST4@pheno+ST5@pheno)/2

#Year 5
ST4 = selectInd(ST3,nS4)
ST4 = setPheno(ST4,varE=eVarSt1,reps=repS45, p=w, fixEff=fxEff)

#Year 4
ST3 = selectInd(ST2,nS3)
ST3 = setPheno(ST3,varE=eVarSt1,reps=repS3, p=w, fixEff=fxEff)

#Year 3
ST2 = selectInd(ST1,nS2, use = "ebv")                   
ST2 = setPheno(ST2,varE=eVarSt1,reps=repS2, p=w, fixEff=fxEff)

#Year 2
ST1 = selectInd(seedlings, nS1, use="ebv")     # next ST1 candidates among seedlings selected based on estimated genetic value
ST1 = setPheno(ST1, varE=eVarSt1, reps=1, p=w, fixEff=fxEff)





