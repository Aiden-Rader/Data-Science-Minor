# Aiden Rader
# 10/06/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Graphics Functions

#=======================================================================================================================================================================================================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Python Programming Assignment: Creative Shapes with Turtle Graphics

# Objective:
# This assignment is designed to help you practice your Python programming skills, focusing on the use of functions, loops, and the Turtle graphics library. You will create a program that draws various shapes with customizable attributes, enhancing your understanding of graphical programming and function definitions in Python.

# Assignment Description:
# Write a Python program that utilizes Turtle graphics to draw a series of shapes based on user-defined functions. The shapes to be drawn include a circle, an square, a star (5-point), and a hexagon. Each shape should be drawn at a specified X and Y location, with customizable size, pen color, and orientation angle.

# For the star, you will need to think creatively about how to use Turtle graphics to achieve the desired appearance, as these shapes are not directly supported by Turtle's standard functions.

# Function Parameters:
# Each function should accept parameters for X, Y (default value of 0 for both), size/radius (default value of 100), angle (default value of 0), and color (default value of "black"). 

# Requirements:
# Use loops within your shape-drawing functions to minimize repetition in your code.
# Incorporate Python's Turtle graphics library to execute the drawing commands.
# Ensure your program includes calls to each shape-drawing function with various sizes, colors, and orientation angles to demonstrate their versatility. Do not ask for user input; instead, hard-code the values for these parameters within your script.
# You will need to use the turtle methods setheading and goto for each shape.
# Include a detailed comment header in your script with the problem description, and comment your code thoroughly to explain your logic and the purpose of each function and parameter.

# Extra Credit:
# Implement an additional function called customshape that draws any shape based on a list of points (list of X and Y coordinates) provided as a parameter. This function should demonstrate the ability to draw complex, custom shapes beyond the predefined ones. Include a sample call for this function as well.

# Submission Instructions:
# Attach your .py Python script file to your submission.
# Generate an image showcasing the drawn shapes in different colors and orientations. Attach this image along with your Python script.
# Ensure your submission includes both the required tasks and the extra credit (if attempted) for full marks

#=======================================================================================================================================================================================================================================================================================================================================#

from turtle import *

# Function that draws a circle at the user-specified position, size, angle, and color
def drawCircle(x=0, y=0, radius=100, angle=0, color="black"):
    penup()
    goto(x,y)  # Go to specified coordinates (x,y)
    setheading(angle)  # Set turtle's heading to the specified angle using user defined angle
    pendown()
    pencolor(color)  # Change pen color
    fillcolor(color) # Change Fill Color aswell
    begin_fill()
    circle(radius)  # Draw a circle with the specified radius
    end_fill()
    penup()

# Function that draws a square at the user-specified position, size, angle, and color
def drawSquare(x=0, y=0, size=100, angle=0, color="black"):
    penup()
    goto(x,y)  # Go to specified coordinates (x,y)
    setheading(angle)  # Set turtle's heading to the specified angle using user defined angle
    pendown()
    pencolor(color)  # Change pen color
    fillcolor(color) # Change Fill Color aswell
    begin_fill()
    for _ in range(4):  # Loop to draw a square
        forward(size)  # Move forward by the specified size
        right(90)  # Turn right by 90 degrees
    end_fill()
    penup()

# Function that draws a 5-point star at the user-specified position, size, angle, and color
def drawStar(x=0, y=0, size=100, angle=0, color="black"):
    penup()
    goto(x,y)  # Go to specified coordinates (x,y)
    setheading(angle)  # Set turtle's heading to the specified angle using user defined angle
    pendown()
    pencolor(color)  # Change pen color
    fillcolor(color) # Change Fill Color aswell
    begin_fill()
    for _ in range(5):  # Loop to draw a star
        forward(size)  # Move forward by the specified size
        right(144)  # Turn right by 144 degrees to create star points
        forward(size)  # Move forward again to complete the inner line
        left(72)  # Turn left to prepare for the next point
    end_fill()
    penup()

# Function that draws a hexagon at the user-specified position, size, angle, and color
def drawHexagon(x=0, y=0, size=100, angle=0, color="black"):
    penup()
    goto(x,y)  # Go to specified coordinates (x,y)
    setheading(angle)  # Set turtle's heading to the specified angle using user defined angle
    pendown()
    pencolor(color)  # Change pen color
    fillcolor(color) # Change Fill Color aswell
    begin_fill()
    for _ in range(6):  # Loop to draw a hexagon
        forward(size)  # Move forward by the specified size
        right(60)  # Turn right by 60 degrees
    end_fill()
    penup()

# Draw a custom shape based on a list of points
def drawCustomShape(points, x=0, y=0, color="black"):
    penup()
    goto(x,y)  # Go to specified coordinates (x,y)
    pendown()
    pencolor(color)  # Change pen color
    fillcolor(color) # Change Fill Color aswell
    begin_fill()
    for point in points:# Loop through points list to draw the shape the user would like
        goto(point[0], point[1])  # Move to each point (x, y)
    goto(points[0])  # Close the shape by going back to the first point
    end_fill()
    penup()

# Main callable function that houses all of the data that we use to make our shapes
def main():

    # Set up basic default turtle screen
    bgcolor('white')
    speed(5)
    
    # use the different functions with various arguments to draw shapes with HARD CODED values
    drawCircle(x=0, y=0, radius=50, angle=0, color="blue")
    drawSquare(x=100, y=100, size=80, angle=45, color="red")
    drawStar(x=-200, y=-200, size=100, angle=30, color="yellow")
    drawHexagon(x=50, y=-150, size=60, angle=0, color="green")

    # Draw a custom shape (diamond) using customShape function, 
    # Side Note: not sure if a diamond is considered very complex/hard shape but it was the first one I thought of!
    drawCustomShape(points=[(-250, 100), (-200, 200), (-150, 100), (-200, 0)], x=-250, y=100, color="purple")


    exitonclick()

# Start the program by just calling the main function here
main()