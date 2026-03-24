

#Chapter 7-test the distribution of a single categorical variable
expected_prop=c(0.25, 0.25, 0.5)
observed_counts= c(142,121,307)
chi_res1=chisq.test(x=observed_counts,p=expected_prop)
chi_res1$expected



#Chapter 7-test the association between two categorical variables
#create the two-way table
tag=matrix(c(33,134,68,121),ncol=2,byrow=T)
colnames(tag)=c("survived","died")
rownames(tag)=c("Metal","Electrical")
#Find the cell percentages
prop.table(tag)
#Find the row percentages
prop.table(tag,1)
#Find the column percentages 
prop.table(tag,2)
#Find the grand total, row total and column total
margin.table(tag)
margin.table(tag,1)
margin.table(tag,2)
#chi-square test results 
chi_res2=chisq.test(tag)
chi_res2$expected
