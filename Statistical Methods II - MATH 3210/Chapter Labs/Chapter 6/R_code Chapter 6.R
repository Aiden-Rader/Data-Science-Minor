#Chapter 6 (Professor Code)

#Example 1 Inferences of one population proportion
prop.test(x=3314,n=17096, conf.level= 0.99)

#Example 2 Inferences of the differences in two population proportions
prop.test(x=c(0.22*1421,0.29*1421),n=c(1421,1421), conf.level= 0.95,alternative="two.sided")

#Example 3 Inferences of one population mean
qqnorm(TV_hour$hours)
qqline(TV_hour$hours)
xbar=mean(TV_hour$hours)
s=sd(TV_hour$hours)
n=length(TV_hour$hours)
t_star=qt(0.975,n-1)
LL=xbar-s*t_star/sqrt(n)
UL=xbar+s*t_star/sqrt(n)
t.test(TV_hour$hours,alternative="two.sided",mu=18.5,conf.level=0.95)

#Example 4 Inferences of the difference in means (two independent samples)
attach(nstreediameter)
N=tapply(dbh,ns,length)
mean=tapply(dbh,ns,mean)
stDev=tapply(dbh,ns,sd)
cbind(N,mean,stDev)
boxplot(dbh~ns,data=nstreediameter)
t.test(dbh~ns,data=nstreediameter,conf.level=0.90,alternative="two.sided")

#Example 5 Inferences of the difference in mean (paired data)

attach(weight_gain)
diff=(Weight_after-Weight_before)*2.20462
qqnorm(diff)
t.test(diff, alternative="two.sided",mu=16)



