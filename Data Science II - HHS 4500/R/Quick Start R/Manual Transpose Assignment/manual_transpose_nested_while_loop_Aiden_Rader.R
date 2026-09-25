# title: Base R - Manually Manually Transpose via Nested While Loops
# author: "Aiden Rader"
# date: "2026-03-30"

# Steps -------------------------------------------------------------------

# Import the census data using Base R (no using readr package!)
census_data <- read.csv("Quick Start R/Manual Transpose Assignment/Datasets/Census_population_files_2000_2010 Clean student.csv")

# Convert the wide census file into long panel format using two nested while loops without using rbind() or cbind().
num_rows <- nrow(census_data)  # get the number of rows in our data frame
num_pop_cols <- ncol(census_data) - 4  # subtracting 4 of our columns (REGION, DIVISION, STATE, NAME) so we get just the population columns
total_rows <- num_rows * num_pop_cols  # getting the absolute amount of rows we need to sufficiently give each state and year a total population

# Assigning each original column as a vector
region <- integer(total_rows)
division <- integer(total_rows)
state <- integer(total_rows)
name <- character(total_rows)
year <- integer(total_rows)
population <- numeric(total_rows)

# Init our counter variables
i <- 1
k <- 1
while (i <= num_rows) {
  j <- 5  # inner loop will start at the first population column
  while (j <= ncol(census_data)) {
    region[k] <- census_data[i, 1]
    division[k] <- census_data[i, 2]
    state[k] <- census_data[i, 3]
    name[k] <- census_data[i, 4]
    year[k] <- 1995 + j  # cheesy way of starting at year 2000 since we know its the first year
    population[k] <- census_data[i, j]

	# Increment variables
    k <- k + 1
    j <- j + 1
  }
  i <- i + 1
}

# Create our new data frame which would be equal to what we just created a vector/object of each iteration
census_data_long <- data.frame(
  region = region,
  division = division,
  state = state,
  name = name,
  year = year,
  population = population
)

# View the long-panel format data
View(census_data_long)
