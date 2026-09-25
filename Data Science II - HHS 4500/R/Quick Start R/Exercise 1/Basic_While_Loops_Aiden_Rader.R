# Quick little while loop excersice

data("mtcars")

mtcars2 <- mtcars

car_count <- 0
rows <- nrow(mtcars2)
i <- 0
while(i <= rows){
	i <- i + 1
	car_count <- car_count + 1
	print(paste("Current Row =", i))
	
	Sys.sleep(0.25)

	if(i==rows) {  # if the incremental var is equal to the number of rows exactly
		print(paste("Final Row Count =", car_count))
		break  # Stop the while loop
	}
}

