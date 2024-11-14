# Aiden Rader
# 11/11/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Rocket Navigation With Background

#==========================================================================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# This assignment builds on the previous assignment. Be sure to use the code from your rocket movement assignment.

# Modify your rocket program to generate and save stars and planets in the background.

# File Check and Generation:
# Write a function called loadstarsplanets():
# Use a try/except block to try to open the file "background.pic".

# If the file does not exist:
# Randomly generate the x, y positions of 10 stars and save them in a stars list.
# Randomly generate the x, y positions of 3 planets and save them in a planets list.
# Save these lists to the file "background.pic" using pickle.
# Draw the stars and planets from their lists.

# If the file does exist:
# Read the lists of star and planet locations from "background.pic" using pickle.
# Draw the stars and planets using the previously saved values.

# Drawing Functions:
# Create drawstars() and drawplanets() functions:
# These functions take x and y as parameters and draw a star or planet at the specified position.

# Main Game Loop:
# Before entering the main game loop, call the loadstarplanet function
# Inside the main game loop, loop through the stars and planets lists, redrawing each object along with the rocket each time.

# Submission:
# Attach your commented .py file to Blackboard.

#==========================================================================================================================================================================================================#

# import libraries
from turtle import *
import pickle
import random

# Set global variables X and Y, and the screen size (height and width)
X, Y = 0, 0
screen_width, screen_height = 400, 400
stars = []
planets = []

# Initialize the turtle with screen size and hide the tracer and turtle (smoother drawing), also now make background black
setup(screen_width, screen_height)
bgcolor('black')
tracer(0)
hideturtle()

# DRAW OBJECT FUNCTIONS #

def drawrocket():
    clear() # clear the current drawing
    penup()
    goto(X, Y) # Move to the rocket's position
    pendown()

    # Drawing a simple triangle as the rocket
    begin_fill()
    color("blue")
    setheading(120)  # Make sure the rocket points up
    for _ in range(3):
        forward(40)
        left(120)
    end_fill()

    # Draw stars and planets in the background
    for star in stars:
        drawstars(star[0], star[1])
    for planet in planets:
        drawplanets(planet[0], planet[1])

    update()  # Update the screen after drawing

def drawstars(x, y):
    penup()
    goto(x, y)
    pendown()
    color("white")
    dot(5)  # Draw a small white dot to represent a star
    penup()

def drawplanets(x, y):
    penup()
    goto(x, y)
    pendown()
    color("red")
    dot(25 )  # Draw a larger red dot to represent a planet
    penup()

# MOVEMENT FUNCTIONS #

def moveup():
    global Y
    Y += 10
    screenwrapping() # Validation method to see if rocket is off the screen
    drawrocket() # redraws the rocket ship after movement

def movedown():
    global Y
    Y -= 10
    screenwrapping() # Validation method to see if rocket is off the screen
    drawrocket() # redraws the rocket ship after movement

def moveright():
    global X
    X += 10
    screenwrapping() # Validation method to see if rocket is off the screen
    drawrocket() # redraws the rocket ship after movement

def moveleft():
    global X
    X -= 10
    screenwrapping() # Validation method to see if rocket is off the screen
    drawrocket() # redraws the rocket ship after movement

# UTILITY FUNCTIONS #

def screenwrapping():
    global X, Y
    # Left/Right wrapping
    if X > screen_width // 2:
        X = -screen_width // 2
    elif X < -screen_width // 2:
        X = screen_width // 2

    # Up/Down wrapping
    if Y > screen_height // 2:
        Y = -screen_height // 2
    elif Y < -screen_height // 2:
        Y = screen_height // 2

def loadstarsplanets():
    # Use global scope variables so we can change them globaly
    global stars, planets
    try:
        # Try to open the file "background.pic" in read-binary ("rb") mode
        with open("background.pic", "rb") as file:
            data = pickle.load(file)
            # Extract the lists of stars and planets from the loaded data
            stars = data["stars"]
            planets = data["planets"]
    except FileNotFoundError:
        # Generate 10 random (x, y) coordinates for stars using list comprehension
        stars = [(random.randint(-screen_width // 2, screen_width // 2), 
              random.randint(-screen_height // 2, screen_height // 2)) for _ in range(10)]

        # Generate 3 random (x, y) coordinates for planets using list comprehension
        planets = [(random.randint(-screen_width // 2, screen_width // 2), 
                random.randint(-screen_height // 2, screen_height // 2)) for _ in range(3)]

         # Open (or create) the file "background.pic" in write-binary ("wb") mode
        with open("background.pic", "wb") as file:
            pickle.dump({"stars": stars, "planets": planets}, file)

# MAIN PROGRAM #

# Load stars and planets before the main game loop
loadstarsplanets()

# Set up turtle to listen for keyboard input and use onKey to trace keystrokes
listen()
onkey(moveup, "Up")
onkey(movedown, "Down")
onkey(moveleft, "Left")
onkey(moveright, "Right")

# Main game loop, initial drawing of the rocket
drawrocket()

# Keep the window open until the user closes it
done()