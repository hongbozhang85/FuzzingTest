library(parallel)

numCores = 2 #detectCores() - 1

cluster = makeCluster(numCores)



stopCluster(cluster)
