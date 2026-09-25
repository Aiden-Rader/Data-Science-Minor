# title: Base-R Exercise 1 - Manipulate mtcars
# subtitle:  "Excercise 1"
# author: "Aiden Rader"
# date: "2026-03-18"

# Steps -------------------------------------------------------------------

# 1. Read-in the mtcars file that is a preloaded practice dataset using R Studio.
data(mtcars)

# 2. Create a copy of the original data frame named "mtcars2," and create a new variable
# "car_name" from the rowname in this new data frame.
mtcars2 <- mtcars
mtcars2$car_name <- rownames(mtcars2)

# 3. Create a numeric ID variable using the rownames function.
mtcars2$id <- as.numeric(as.factor(rownames(mtcars2)))

# 4. Drop the rowname column by using the rownames and <- NULL functions.
rownames(mtcars2) <- NULL

# 5. Use the summary function to find the first and third quartile and mean and median of
# the "wt" (weight) variable.
wt_summary <- summary(mtcars2$wt)
print(wt_summary)
# wt summary values:
# Min.   1st Qu.  Median  Mean    3rd Qu.  Max.
# 1.513   2.581   3.325   3.217   3.610   5.424

# 6. Create a new variable (new_weight) that classifies weight into three levels ("light",
# "medium", "heavy") based on the first and third quartile weights (from summary) to define
# the three categories.
mtcars2$new_weight <- NA
mtcars2$new_weight[mtcars2$wt <= wt_summary["1st Qu."]] <- "light"
mtcars2$new_weight[mtcars2$wt > wt_summary["1st Qu."] & mtcars2$wt <= wt_summary["3rd Qu."]] <- "medium"
mtcars2$new_weight[mtcars2$wt > wt_summary["3rd Qu."]] <- "heavy"

# 7. Perform a frequency count of the new_weight variable and report the count via a comment.
new_weight_count <- table(mtcars2$new_weight)
print(new_weight_count)
# Frequency count:
# heavy = 8, light = 8, medium = 16

# 8. Add a new car to the dataframe by creating a new row (vector) of data that includes the data (listed on the assignment docx)
new_car <- data.frame(
  car_name = "Chrysler_300",
  mpg = 21,
  cyl = 6,
  disp = 111,
  hp = 175,
  drat = 4.11,
  wt = 2.9,
  qsec = 18.50,
  vs = 1,
  am = 1,
  gear = 4,
  carb = 1,
  id = max(mtcars2$id) + 1,  # Since id and new_weight are already inside the dataframe, we need to add them to the new row as well!
  new_weight = "medium"
)

# Add the new car to the dataframe
mtcars3 <- rbind(mtcars2, new_car)

# 9. Sort all cars by mpg and report the number of cars with gas mileage higher than 19 mpg.
mtcars_sorted <- mtcars3[order(mtcars3$mpg), ]
print(mtcars_sorted[, c("car_name", "mpg")])

cars_above_19 <- sum(mtcars_sorted$mpg > 19)
print(cars_above_19)
# Number of cars with gas mileage higher than 19 mpg: 18

# 10. Create a dataframe named "good_mpg" that includes only vehicles with gas mileage above 20 mpg.
good_mpg <- mtcars_sorted[mtcars_sorted$mpg > 20, ]
print(good_mpg)

# 11. Submit your R.script via Blackboard with comments including your name.

# SEE SUBMISSION! #