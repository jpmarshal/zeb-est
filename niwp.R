(beta0 <- runif(1, 1, 3))
(beta1 <- 0)#runif(1, 0, 5))
lsigma <- runif(1, -5, 5)
sigma <- exp(lsigma)
tau <- 1/(sigma*sigma)
psi <- runif(1, 0.5, 0.9)
d <- runif(5, 0, 0.2)

(w <- rbinom(1, 1, psi))

#h[i,k,j] <- exp(-beta0 - beta1*d[i,k,j]) # Gompertz
(log(h) <- -beta0 - beta1*d*d) # SqDist
#h[i,k,j] <- exp(-log(1 - expit(beta0)*exp(beta1*pow(d[i,k,j]), 2))) # NormKern
#(h <- exp(-beta0 - beta1*log(d))) # Weibull
(H <- sum(h))
(p <- (1 - exp(-H)))
#(y <- rbinom(1, 1, p))
