# Aiden Rader
# 10/27/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Class Graphics

#===========================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Python Programming Assignment: Class-Based Graphics with Turtle

# Objective:
# This assignment is designed to enhance your understanding of class-based programming in Python, focusing on the implementation of encapsulation and method 
# definitions. Using the Turtle graphics library, you will create classes to draw various geometric shapes, each with customizable attributes. This approach 
# will help you appreciate the benefits of organizing code into modular, reusable components.

# Assignment Description:
# Develop a Python program that employs the Turtle graphics library to draw a collection of shapes, including a circle, a square, a star (5-point), and 
# a hexagon. Each shape will be represented by its own class, with each class containing methods to initialize the shape's properties and to draw the shape 
# on the screen. These properties include the shape's position (X, Y coordinates), size, pen color, and orientation angle.  Your code should be based on 
# your code from the previous function assignment. 

# Shape Specifications:
# Separate Classes: Implement a separate class for each shape: Circle, Square, Star, and Hexagon. 
# Common Methods: Each class should include an __init__ method to initialize the shape's attributes and a draw method to define how the shape is drawn 
# using Turtle graphics.

# Set & Get Methods:
# Create a set and get method for the size or radius attribute for each class and include example method calls for each.

# Class Attributes:
# Attributes for each class should include X and Y coordinates (defaulting to 0), size/radius (defaulting to 100), orientation angle (defaulting to 0), 
# and color (defaulting to "black").

# Requirements:
# Each shape class must encapsulate its own data and behavior, demonstrating the principle of encapsulation.
# Avoid redundancy by using Turtle's drawing commands efficiently within each draw method.
# Demonstrate that you can convert functions into classes and methods.
# Instantiate objects of each shape class with various sizes, colors, and orientation angles to display their versatility. These parameters should be 
# hardcoded in your script, with no user input required.
# Ensure that each class has a method to position the shape using Turtle's setheading and goto methods before drawing.

# Documentation:
# Provide a comprehensive comment header in your script, detailing the assignment purpose, a description of each class, and the purpose of the __init__ 
# and draw methods.

# Comment your code to clarify the logic behind your shape drawing implementations and the use of class-based programming concepts.

# Extra Credit:
# The CustomShape class should accept a list of (X, Y) coordinates and draw a shape based on these points. This will challenge your ability to handle 
# more complex, dynamic data structures within a class-based framework. 

# Submission Instructions:
# Attach your .py Python script file.
# Include an image showcasing the shapes drawn in different colors and orientations as part of your submission.
# Make sure your submission meets all the outlined requirements for full credit.

# Evaluation Criteria:
# Proper implementation of class-based programming concepts.
# The functionality and visual accuracy of the drawn shapes.
# Code organization, readability, and documentation.
# The creative and effective implementation of the CustomShape class for extra credit.
# This assignment aims to solidify your understanding of using classes in Python to manage and organize code effectively, promoting good software design practices.
# Attach your .py file to Blackboard.

#===========================================================================================================================================================#

# import turtle library 
from turtle import *

# Setup for Circle class, Represents a circle with customizable attributes
class Circle:

    # Initializes the circle's position (x, y), radius, color, and orientation angle
    def __init__(self, x=0, y=0, radius=100, color="black", angle=0):
        self.x = x
        self.y = y
        self.radius = radius
        self.color = color
        self.angle = angle

    # Setter method for setting radius for the circle
    def set_radius(self, radius):
        self.radius = radius

    # Getter method for getting radius for the circle
    def get_radius(self):
        return self.radius

    # Draws the circle at the specified position with the given radius and color
    def draw(self):
        penup()
        goto(self.x, self.y - self.radius) # Move to the starting position
        setheading(self.angle)
        pendown()
        color(self.color) # Set the color of the cirlce
        begin_fill()
        circle(self.radius) # Create the circle based on the radius we set
        end_fill()

# Setup for Square class, Represents a square with customizable attributes
class Square:

    # Initializes the square's position (x, y), size, color, and orientation angle
    def __init__(self, x=0, y=0, size=100, color="black", angle=0):
        self.x = x
        self.y = y
        self.size = size
        self.color = color
        self.angle = angle

    # Setter method for setting the size of the square
    def set_size(self, size):
        self.size = size

    # Getter method for getting the size of the square
    def get_size(self):
        return self.size

    # Draws the square at the specified position with the given size and color
    def draw(self):
        penup()
        goto(self.x, self.y) # Move to the starting position
        setheading(self.angle)
        pendown()
        color(self.color) # Set the color of the square
        begin_fill()
        for _ in range(4): # Loop to draw the four sides of the square
            forward(self.size) # Draw one side
            right(90) # Turn right by 90 degrees
        end_fill()

# Setup for (5-point) Star class, Represents a 5-point star with customizable attributes
class Star:

    # Initializes the star's position (x, y), size, color, and orientation angle
    def __init__(self, x=0, y=0, size=100, color="black", angle=0):
        self.x = x
        self.y = y
        self.size = size
        self.color = color
        self.angle = angle

    # Setter method for setting the size of the star
    def set_size(self, size):
        self.size = size

    # Getter method for getting the size of the star
    def get_size(self):
        return self.size

    # Draws the star at the specified position with the given size and color
    def draw(self):
        penup()
        goto(self.x, self.y) # Move to the starting position
        setheading(self.angle)
        pendown()
        color(self.color) # Set the color of the star
        begin_fill()
        for _ in range(5): # Loop to draw the five points of the star
            forward(self.size) # Draw one point
            right(144) # Turn right by 144 degrees to form a star point
            forward(self.size) # Move forward again to complete the inner line
            left(72) # Turn left to prepare for the next point
        end_fill()

# Setup for Hexagon class, Represents a hexagon with customizable attributes
class Hexagon:

    # Initializes the hexagon's position (x, y), size, color, and orientation angle
    def __init__(self, x=0, y=0, size=100, color="black", angle=0):
        self.x = x
        self.y = y
        self.size = size
        self.color = color
        self.angle = angle

    # Setter method for setting the size of the hexagon
    def set_size(self, size):
        self.size = size

    # Getter method for getting the size of the hexagon
    def get_size(self):
        return self.size

    # Draws the hexagon at the specified position with the given size and color
    def draw(self):
        penup()
        goto(self.x, self.y)  # Move to the starting position
        setheading(self.angle)
        pendown()
        color(self.color)  # Set the color of the hexagon
        begin_fill()
        for _ in range(6): # Loop to draw the six sides of the hexagon
            forward(self.size) # Draw one side
            right(60) # Turn right by 60 degrees
        end_fill()

# Setup for CustomShape class, Represents a custom shape defined by a list of coordinates
class CustomShape:

    # Initializes the custom shape's coordinates and color
    def __init__(self, coordinates, color="black"):
        self.coordinates = coordinates
        self.color = color

    # Draws the custom shape using the specified coordinates and color
    def draw(self):
        penup()
        goto(self.coordinates[0]) # Move to the first coordinate
        pendown()
        color(self.color) # Set the color of the custom shape
        begin_fill()
        for coord in self.coordinates: # Loop through each coordinate
            goto(coord) # Draw to the next coordinate
        goto(self.coordinates[0]) # Close the shape by returning to the first coordinate
        end_fill()

# MAIN METHOD AREA #
def main():
    bgcolor('white')
    speed(5)

    # Create instances of shapes with various HARDCODED attributes
    circle = Circle(x=0, y=0, radius=50, color="blue", angle=0)
    square = Square(x=100, y=100, size=80, color="red", angle=45)
    star = Star(x=-200, y=-200, size=100, color="yellow", angle=30)
    hexagon = Hexagon(x=50, y=-150, size=60, color="green", angle=0)

    # Draw the shapes using draw method(s)
    circle.draw()
    square.draw()
    star.draw()
    hexagon.draw()

   # Draw a custom shape (diamond) using customShape class methods
    # Side note: this is the same exact shape as my last submission; however, I refined the draw function this time!
    custom_shape = CustomShape(coordinates=[(-250, 100), (-200, 200), (-150, 100), (-200, 0)], color="purple")
    custom_shape.draw()

    exitonclick()

# Start the program by just calling the main function here
main()