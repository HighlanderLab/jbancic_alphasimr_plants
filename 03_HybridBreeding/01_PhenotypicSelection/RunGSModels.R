# Run genomic models

cat("  Running GS model\n")
gsModelM = RRBLUP(MaleTrainPop)
gsModelF = RRBLUP(FemaleTrainPop)