# Aiden Rader
# 11/13/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Iteration and Recursion

#==========================================================================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Objective: Understand and implement both iterative and recursive approaches to calculate the power of a number without using ** or pow().

# Background:
# Calculating the power of a number is a fundamental operation in mathematics, where you multiply a number (the base) by itself a certain number of times (the exponent).
# This assignment will challenge you to implement this operation in Python first using an iterative method and then using recursion, deepening your understanding of both approaches.

# Note that you can assume that the exponent is a positive integer.

# Part 1: Iterative Power Function

# Function Implementation:
# Write a Python function that takes two arguments: base and exponent.
# The function should calculate the power of the base to the exponent iteratively (using a loop) to multiply base by itself.
# Explicit use of the ** operator or the pow() function is not allowed.
# Remember that anything to the 0 power is 1.
# Call the function with ipower(base,exponent)
# Don't worry about error checking the input, assume that exponent is a positive integer.

# Test Cases:
# Demonstrate your function's correctness with at least two test cases.

# Part 2: Recursive Power Function

# Function Implementation:
# Write another Python function following the same requirements and restrictions as in Part 1, but implement it using recursion.
# Call the function with rpower(base,exponent)
# Remember that anything to the 0 power is 1 (base case).
# Ensure your recursive solution correctly handles the base case and recursive step without using iterative loops, **, or pow().

# Considerations:
# Your solution must exclusively use recursion for the function.
# Include comments in your code explaining the logic behind your base case and the recursive step.

# Test Cases:
# Use the same test cases applied to the iterative function to demonstrate the correctness of your recursive function. This will help in comparing both implementations.
# Submission Guidelines:
# Submit a .py file to blackboard containing both your iterative and recursive functions along with the test cases.
# Your code should be clean, well-commented, and easy to understand, highlighting the differences and similarities between iterative and recursive approaches.

# Evaluation Criteria:
# Correctness: Both functions should accurately calculate the power of a number for all provided test cases.
# Implementation: The iterative function must use a loop, and the recursive function must correctly implement recursive logic.
# Code Quality: Code should be well-structured, with clear comments explaining the implementation.
# Understanding: Your comments and code should reflect a clear understanding of both iterative and recursive approaches.
# By completing this assignment, you will not only practice implementing algorithms in Python but also gain insights into the strengths and nuances of iterative versus recursive problem-solving strategies.

#==========================================================================================================================================================================================================#

# FUNCTION BLOCKS #

# Iterative approach
def ipower(base, exponent):
	res = 1  # By default we should set the res to 1 since #^0 = 1
	for i in range(exponent):
		res *= base  # Multiply res by base exponent amount of times then return result after for loop
	return res

# Recursive approach
def rpower(base, exponent):
	# Base case: When exponent is 0, return 1
	if (exponent == 0):
		return 1

	# Recursion step: Multiply the base by the result of the function (rpower) with the base and decremented exponenet (exponent - 1)
	return base * rpower(base, exponent - 1)

# MAIN CODE #

# Set up easily changable bases and exponents
base1, base2 = 2, 5
exponent1, exponent2 = 4, 5

# Display results for iterative function
print(f'Iterative approach (with Base: {base1} to the power of: {exponent1}): {ipower(base1,exponent1)}')
print(f'Iterative approach (with Base: {base2} to the power of: {exponent2}): {ipower(base2,exponent2)}')
print('\n')

# Display results for recursive function
print(f'Recursive approach (with Base: {base1} to the power of: {exponent1}): {rpower(base1,exponent1)}')
print(f'Recursive approach (with Base: {base2} to the power of: {exponent2}): {rpower(base2,exponent2)}')
print('\n')

# Testing our test cases with our functions (validity testing)
if (ipower(base1, exponent1) == base1**exponent1 and ipower(base2, exponent2) == base2**exponent2 and rpower(base1, exponent1) == base1**exponent1 and rpower(base2, exponent2) == base2**exponent2):
	print("All tests passed!")
else:
	print("One or more tests have failed!")