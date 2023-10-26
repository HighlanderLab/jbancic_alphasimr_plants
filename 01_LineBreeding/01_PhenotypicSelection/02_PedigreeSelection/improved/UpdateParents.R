#-----------------------------------------------------------------------
# Update parents
#-----------------------------------------------------------------------
cat(" Select new parents \n")

# Replace 10 oldest parents with 10 new parents from S6_EYT stage
Parents = c(Parents[11:nParents], S6_EYT)
