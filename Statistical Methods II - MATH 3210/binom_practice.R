# A very good basketball player makes about 90% of his free throws. 
# If we assume successive attempts are independent, what is the 
# probability the player makes at least 8 free throws in 10 attempts?

# My dumb way to do it
x8 <- dbinom(8,10,0.9)
x9 <- dbinom(9,10,0.9)
x10 <- dbinom(10,10,0.9)

res <- x8 + x9 + x10

# here is the cleaner version of how to do it
better_res <- sum(dbinom(8:10,10,0.9))

# more exmaples

free_throw_res <- sum(dbinom(250:290,290,0.9))

test <- dbinom(8,10,0.66)

none <- dbinom(0,50,0.033)
one <- dbinom(1,50,0.033)
two <- dbinom(2,50,0.033)

mu1 <- 10 * 0.66
std1 <- sqrt(mu1*(1-0.66))

mu2 <- 50 * 0.033
std2 <- sqrt(mu2*(1-0.033))
