# Homework R Code for Section 8.1


# Question 4 --------------------------------------------------------------

SSG <- 122
SSE <- 279
SST <- 401

n1 <- n2 <- n3 <- 6
n_tot <- sum(n1, n2, n3)

k <- 3

df_group <- k - 1
df_error <- n_tot - k
df_total <- n_tot - 1

# Calcuate our mean squares
MSG <- SSG / (df_group)
MSE <- SSE / (df_error)

# Finding f stat with our MSG and MSE
f_stat <- MSG/MSE
format(f_stat, 2)


# Question 5 -------------------------------------------------------------

SSG <- 810
SSE <- 5770
SST <- 6580

n1 <- n2 <- n3 <- n4 <- 11
n_tot <- sum(n1, n2, n3, n4)

k <- 4  # n1,n2,n3.n4

df_group <- k - 1
df_error <- n_tot - k
df_total <- n_tot - 1

# Calcuate our mean squares
MSG <- SSG / (df_group)
MSE <- SSE / (df_error)

# Finding f stat with our MSG and MSE
f_stat <- MSG/MSE


# Question 6 --------------------------------------------------------------

SSG <- 360.0
SSE <- 1200.0
SST <- 1560.0

k <- 4

df_group <- 3
df_error <- 16
df_total <- 19

# Calcuate our mean squares
MSG <- 120.0
MSE <- 75.0

# Finding f stat with our MSG and MSE
f_stat <- 1.60

p_val <- 1 - pf(f_stat, df_group, df_error)
p_val

reject_H0 <- p_val <= 0.05
reject_H0

# Question 7 --------------------------------------------------------------

SSG <- 1200.0
SSE <- 1837.5
SST <- 3037.5

k <- 5

df_group <- 4
df_error <- 35
df_total <- 39

# Calcuate our mean squares
MSG <- 300.0
MSE <- 52.5

# Finding f stat with our MSG and MSE
f_stat <- 5.71

p_val <- 1 - pf(f_stat, df_group, df_error)
p_val

reject_H0 <- p_val <= 0.05
reject_H0


# Question 8 --------------------------------------------------------------

# A recent study1 examined the impact of a mother's voice on stress levels in young girls. The study included 68 girls ages 7 to 12 who
# reported good relationships with their mothers. Each girl gave a speech and then solved mental arithmetic problems in front of
# strangers. Cortisol levels in saliva were measured for all girls and were high, indicating that the girls felt a high level of stress from
# these activities. (Cortisol is a stress hormone and higher levels indicate greater stress.) After the stress-inducing activities, the girls
# were randomly divided into four equal-sized groups: one group talked to their mothers in person, one group talked to their mothers
# on the phone, one group sent and received text messages with their mothers, and one group had no contact with their mothers.
# Cortisol levels were measured before and after the interaction with mothers and the change in the cortisol level was recorded for
# each girl. The researchers are testing to see if there is a difference in the change in cortisol level depending on the type of interaction
# with mom.

# a.) is this an expereiment or an observational study?
# Experiment, because its not examining what happens naturally it assigns treatments

# b.) What are the total degrees of freedom?

n <- 68
k <- 4

df_groups <- k - 1

df_error <- n - k

df_total <- n - 1

# c.) 

# Question 9 --------------------------------------------------------------

# Is Pressure at School Related to Time with Friends? Exercise 1.24 introduces a survey given to a sample of high school seniors in
# Pennsylvania. Two of the variables in the survey are HangHours, the number of hours per week spent hanging out with friends, and
# SchoolPressure, the amount of pressure felt due to schoolwork (None, Very little,Some, or A lot). We wish to test whether the amount
# of school pressure felt by students is related to the mean time hanging out with friends. The data are stored in PASeniors and output
# for an ANOVA test is shown below, along with some summary statistics.

reject_H0 <- 0.003 <= 0.05
reject_H0


# Question 10 -------------------------------------------------------------

# A study is designed to examine the effect of doing synchronized movements (such as marching in step or doing synchronized dance
# steps) and the effect of exertion on many different variables, including how close participants feel to others in their group. In the
# study, high school students in Brazil were randomly assigned to an exercise with either high synchronization (HS) or low
# synchronization (LS) and also either to high exertion (HE) or low exertion (LE). Thus, there are four groups: HS+HE, HS+LE, LS+HE,
# and LS+LE. Closeness is measured on a 7-point Likert scale (1 =least close to 7 =most close), and the response variable is the
# change in how close participants feel to those in their group using the rating after the exercise minus the rating before the exercise.
# The data are stored in SynchronizedMovement and output for an ANOVA test is shown below, along with some summary statistics.

attach(SynchronizedMovement)


# (a) In both groups with high synchronization (HS), does mean closeness rating go up or down after the synchronized exercise?


# (b) In the groups with low synchronization (LS), does mean closeness rating go up or down if the group engages in high exertion
# (HE) exercise?

# In the groups with low synchronization (LS), does mean closeness rating go up or down if the group engages in low exertion (LE)
# exercise?

# (c) How many students were included in the analysis?

# (d) At a 5% level, what is the conclusion of the test?

anova <- aov(CloseDiff ~ Synch * Exertion)

# (e) At a 1% level, what is the conclusion of the test?


# Question 11 -------------------------------------------------------------

# Color affects us in many ways. For example, experiments have shown that the color red appears to enhance men's attraction to
# women. Previous studies have also shown that athletes competing against an opponent wearing red perform worse, and students
# exposed to red before a test perform worse.1 A recent study2 states that "red is hypothesized to impair performance on achievement
# tasks, because red is associated with the danger of failure." In the study, US college students were asked to solve 15 moderately
# difficult, five-letter, single-solution anagrams during a 5-minute period. Information about the study was given to participants in
# either red, green, or black ink just before they were given the anagrams. Participants were randomly assigned to a color group and
# did not know the purpose of the experiment, and all those coming in contact with the participants were blind to color group. The red
# group contained 19 participants and they correctly solved an average of 4.4 anagrams. The 27 participants in the green group
# correctly solved an average of 5.7 anagrams and the 25 participants in the black group correctly solved an average of 5.9 anagrams.
# Work through the details below to test if performance is different based on prior exposure to different colors.

k <- 3

n_red <- 19
s_red <- 4.4

n_green <- 27
s_green <- 5.7

n_black <- 25
s_black <- 5.9

n <- c(n_red, n_green, n_black)

n_tot <- sum(n)

df_group <- k - 1
df_error <- n_tot - k
df_total <- n_tot - 1

SSG <- 27.7
SST <- 84.7

SSE <- SST - SSG

MSG <- SSG / (df_group)
MSE <- SSE / (df_error)

# Finding f stat with our MSG and MSE
f_stat <- MSG / MSE

p_val <- 1 - pf(f_stat, df_group, df_error)
format(round(p_val,3), scientific = FALSE) 

reject_H0 <- p_val <= 0.05
reject_H0
