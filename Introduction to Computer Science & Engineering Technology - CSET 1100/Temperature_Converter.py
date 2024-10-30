# Aiden Rader
# 09/17/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Temperature Converter

#===========================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Overview
# In this assignment, you will create a Python program that converts temperatures between Fahrenheit and Celsius. The program will prompt the user to enter a temperature in Fahrenheit and convert it to Celsius, or vice versa, depending on the user's choice. This assignment will help you practice using loops, if statements, and user input/output in Python.

# Objectives
# Use if statements to handle conditional logic.
# Implement loops to allow multiple conversions without restarting the program.
# Apply input and output operations to interact with the user.
# Requirements
# User Choice: The program should first ask the user whether they want to convert a temperature from Fahrenheit to Celsius or from Celsius to Fahrenheit. Use input to get the user's choice and use an if statement to determine which formula to use.  Allow for upper and lowercase characters.

# Temperature Input: Prompt the user to input the temperature.

# Conversion:

# If converting from Fahrenheit to Celsius, use the formula: C = (F - 32) * 5/9.
# If converting from Celsius to Fahrenheit, use the formula: F = C * 9/5 + 32.
# Perform the conversion and display the result to the user.
# Loop for Multiple Conversions: After displaying the conversion result, ask the user if they want to perform another conversion. The program should continue running until the user chooses to exit.  This will require a while loop.

# Example Output
# Would you like to convert temperature from:
# F: Fahrenheit to Celsius
# C: Celsius to Fahrenheit
# Enter your choice (F or C): C
# Enter temperature in Celsius: 25
# 25 C is 77.0 F.
# Do you want to perform another conversion? (Y/N): Y
# Would you like to convert temperature from:
# F:  Fahrenheit to Celsius
# C: Celsius to Fahrenheit
# Enter your choice (F or C): F
# Enter temperature in Fahrenheit: 77
# 77 F is 25.0 C.
# Do you want to perform another conversion? (Y/N): N
# Goodbye!

# Submission Guidelines
# Ensure your code is well-commented with my instructions at the beginning as comments and your explaination next to the code.
# Test your program with various inputs to ensure it performs the conversions correctly

#===========================================================================================================================================================#

# MAIN PROGRAM #

# While loop makes it so we can move through the main program without having to restart the program
while True:
    # Main print message and explanation before user input
    print("Would you like to convert temperature from: ")
    print("F: Fahrenheit to Celsius")
    print("C: Celsius to Fahrenheit")

    # Make user input either F or C, automatically upper case the user input
    temp_choice = input("Enter your choice (F or C): ").upper()

    # If temp choice input is Celcius, input temp in C, conversion function, print result
    if (temp_choice == "C"):
        celsius = float(input("Enter temperature in Celsius: "))
        fahrenheit = celsius * 9 / 5 + 32
        print(str(celsius) + " C is " + str(fahrenheit) + " F")

    # If temp choice input is Fahrenheit, input temp in F, conversion function, print result
    elif (temp_choice == "F"):
        fahrenheit = float(input("Enter temperature in Fahrenheit: "))
        celsius = (fahrenheit - 32) * 5 / 9
        print(str(fahrenheit) + " F is " + str(celsius) + " C")

    # If temp choice input is invalid (not F or C), go back if an invalid option is entered!
    else:
        print(temp_choice + " is not an option, please try again.")
        continue

    # Using another while loop to ask the user if they want to perform another conversion
    while True:

        # user input for if they want to do another conversion, automatically uppercases the input
        another_conversion = input("Do you want to perform another conversion? (Y/N): ").upper()

        # If input is "N" then exit/end entire program
        if another_conversion == "N":
            print("Goodbye!")
            exit()

        # If input is "Y" then break out of this while loop and loop back around from the beginning
        elif another_conversion == "Y":
            break

        # If input is neither "Y" or "N" then notify user and reloop through parent while loop
        else:
            print("That is neither Y nor N. Please enter Y or N.")