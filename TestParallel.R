library(parallel)

this_cluster <- makeCluster(3)

set.seed(10120)
# Simulate some data
myData <- rgamma(1000, shape = 0.4, rate = 0.8)

# Create a function with all the needed code
run_MCMC_allcode <- function(seed, data) {
  library(nimble)
  
  myCode <- nimbleCode({
    a ~ dunif(0, 100)
    b ~ dnorm(0, 100)
    
    for (i in 1:length_y) {
      y[i] ~ dgamma(shape = a, rate = b)
    }
  })
  
  #myModel <- nimbleModel(code = myCode,
  #                       data = list(y = data),
  #                       constants = list(length_y = 1000),
  #                       inits = list(a = 0.5, b = 0.5))
  
  #CmyModel <- compileNimble(myModel)
  
  #myMCMC <- buildMCMC(CmyModel)
  #CmyMCMC <- compileNimble(myMCMC)
  
  #results <- runMCMC(CmyMCMC, niter = 10000, setSeed = seed)
  results <- nimbleMCMC(code = myCode, data = list(y = data),
                        constants = list(length_y = 1000),
                        inits = list(a = 0.5, b = 0.5),
                        niter = 10000, setSeed = seed)
  
  return(results)
}

chain_output <- parLapply(cl = this_cluster, X = 1:3, 
                          fun = run_MCMC_allcode, 
                          data = myData)

save(chain_output, file = 'output.RData')

#par(mfrow = c(2,2))
#for (i in 1:3) {
#  this_output <- chain_output[[i]]
#  plot(this_output[,"b"], type = "l", ylab = 'b')
#}
