# Function to process data and calculate the average
def process_data(numbers):
    total=0
    for i in numbers: # Calculate the sum of the numbers
        total+=i
    return total / len(numbers) # Return the average of the numbers

# List of numbers for processing
numbers = [10, 20, 30, 40, 50, 60]

# Call the process_data function with the list of numbers
result = process_data(numbers)


# Print the result
print("Average=",result)

# Introduce a division by zero error for demonstration (Task 5)
error_trigger = 1 / 0 # This line will cause a division by zero exception