# TENR Zebra SCR analysis - Process data for grid analysis from search path
# Set for parallel running on cluster

## set up workspace
library(jagsUI)

# load data
load('spacing100.RData')
my.data <- c(zebData[[1]], zebData[[2]])

# run step2 for s and w
my.inits <- function(){ zebData[[3]]}

my.params <- zebData[[4]]

## model specification in BUGS
cat('
model{

# Priors
beta0 ~ dunif(-1, 5)
beta1 ~ dunif(4, 25)
lsigma ~ dunif(-1, 0.5)
sigma <- exp(lsigma)
tau <- 1/(sigma*sigma)
psi ~ dunif(0, 1)

# Likelihood
for(i in 1:M){ # Loop over individuals
  w[i] ~ dbern(psi)
  s[i,1] ~ dunif(Xl, Xu)
  s[i,2] ~ dunif(Yl, Yu)
  for(k in 1:K){ # Loop over temporal replicates
    u[i,k] ~ dnorm(s[i,1], tau)
    v[i,k] ~ dnorm(s[i,2], tau)
    for(j in 1:J){ # Loop over each point defining line segments
      d[i,k,j] <- pow(pow(u[i,k] - X[j,1,k], 2) + pow(v[i,k] - X[j,2,k], 2), 0.5)
      #h[i,k,j] <- exp(-beta0 - beta1*d[i,k,j]) # Gompertz
      #h[i,k,j] <- exp(-beta0 - beta1*d[i,k,j]*d[i,k,j]) # SqDist
      h[i,k,j] <- exp(-log(1 - expit(beta0)*exp(beta1*pow(d[i,k,j]), 2))) # NormKern
      #h[i,k,j] <- exp(beta0 + beta1*log(d[i,k,j])) # Weibull

      # Bayesian p-value
      mu[i,k,j] <- w[i]*p[i,k]
      mu2[i,k,j] <- mu[i,k,j]*K
    }
    H[i,k] <- sum(h[i,k,1:J])
    p[i,k] <- w[i]*(1 - exp(-H[i,k]))
    y[i,k] ~ dbern(p[i,k])
    ynew[i,k] ~ dbern(p[i,k])
  }
  # Bayesian p-value GOF: discrepancy across individuals
  expected.t2[i] <- sum(mu2[i,,])
  nsum.t2[i] <- sum(y[i,])
  nsumnew.t2[i] <- sum(ynew[i,])
  err.t2[i] <- pow(pow(nsum.t2[i], 0.5) - pow(expected.t2[i], 0.5), 2)
  errnew.t2[i] <- pow(pow(nsumnew.t2[i], 0.5) - pow(expected.t2[i], 0.5), 2)
}

# Derived quantity
N <- sum(w[])
T1obs <- sum(err.t2[])
T1new <- sum(errnew.t2[])
}
', file = 'modelnormKern.txt')

# MCMC settings
nc <- 3
ni <- 15000
nb <- 5000
nt <- 10

(start.time <- Sys.time())
out <- jags(data = my.data, inits = my.inits, parameters.to.save = my.params,
            n.iter = ni, n.burnin = nb, n.thin = nt, n.chains = nc,
            model.file = 'modelnormKern.txt', parallel = T)
(end.time <- Sys.time())
print(difftime(end.time, start.time, units = 'hours'), 3)

save(out, file = 'normKern100Out.RData')
