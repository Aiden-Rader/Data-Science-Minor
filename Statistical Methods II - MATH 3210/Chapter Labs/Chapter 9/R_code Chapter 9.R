attach(pabmi)
plot(PA,BMI)
pabmi.lm=lm(BMI~PA,data=pabmi)
abline(pabmi.lm)
summary(pabmi.lm)

#check the conditions for simple linear regression model 
#residual against the explanatory variable
plot(PA,residuals(pabmi.lm),xlab="PA(thousands of steps)",ylab="Residuals")

#qq plot for the residual
qqnorm(residuals(pabmi.lm),xlab="Normal Score", ylab="Residuals")
qqline(residuals(pabmi.lm))

#Find the confidence interval for mean response
newdata=data.frame(PA=9.5)

#Find the prediction interval for a future observation
predict(pabmi.lm,newdata,interval="confidence")
predict(pabmi.lm,newdata,interval="predict")

#Produce the ANOVA table
anova(pabmi.lm)

#correlation test
cor.test(PA,BMI)

