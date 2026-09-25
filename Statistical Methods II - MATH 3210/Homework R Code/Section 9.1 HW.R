# Homework: Section 9.1


# Question 7 --------------------------------------------------------------

library(readxl)
StudentSurvey <- read_excel("Homework R Code/Datasets/StudentSurvey.xlsx")
View(StudentSurvey)

attach(StudentSurvey)

model <- lm(GPA ~ VerbalSAT, data = StudentSurvey)
mod_sum <- summary(model)
mod_sum

# Predicting the GPA with a score on the verbal SAT exam of 610
verb_610 <- predict(model, newdata = data.frame(VerbalSAT = 610))
format(verb_610, 2)

# Plotting the scatter plot
plot(StudentSurvey$VerbalSAT, StudentSurvey$GPA)
abline(model, col = "blue")

# Est. Slope 
coef(model)  # <- this can be seen in our summary as well! 

# formatting the p val 

format(1.45e-11)

# Question 8 --------------------------------------------------------------

BMGain <- 1.11 + 0.127 * (59)
