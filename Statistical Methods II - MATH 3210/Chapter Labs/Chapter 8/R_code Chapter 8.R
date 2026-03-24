attach(Cuckoo_Eggs)
install.packages("mosaic")
require(mosaic)
boxplot(length~species)
favstats(length~species,data=Cuckoo_Eggs)
#ANOVA to compare the means
Cuckoo_anova=aov(length~species,data=Cuckoo_Eggs)
summary(Cuckoo_anova)
#pairwise comparison
pairwise.t.test(length,species,p.adj="none")
pairwise.t.test(length,species,p.adj="bonf")
#check normality
qqnorm(resid(Cuckoo_anova))
qqline(resid(Cuckoo_anova))
