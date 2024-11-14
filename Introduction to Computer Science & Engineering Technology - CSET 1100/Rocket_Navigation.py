# Aiden Rader
# 10/30/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Rocket Navigation

#==========================================================================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Objective:

# Write a Python program that displays a rocket on the screen, allowing it to be moved around using the arrow keys. The rocket should wrap around the screen when it reaches the edges.

# Instructions:

# Initialize Global Variables:
# Create two global variables X and Y and set their initial values to 0. These variables will track the rocket's current position on the screen.

# Drawing Function:
# Write a function named drawrocket that will draw the rocket at the coordinates specified by the global variables X and Y. Ensure that you use absolute coordinates for placing the rocket on the screen.

# Handle Key Presses:
# Modify the keypress handling code to adjust the values of X and Y based on the arrow keys:
# Pressing the "Up" arrow should increase Y, moving the rocket up.
# Pressing the "Down" arrow should decrease Y, moving the rocket down.
# Pressing the "Right" arrow should increase X, moving the rocket right.
# Pressing the "Left" arrow should decrease X, moving the rocket left.
# Include global X and global Y in the respective key functions so that these global variables are modified correctly.

# Real-Time Drawing:
# Include a the clear and update methods are part of the main game loop, which loops forever.  
# Look at the examples which we covered in class and 
# Ensure the drawrocket function is called inside the main game loop so that the rocket's position updates in real-time as the arrow keys are pressed.

# Screen Wrapping:
# Implement screen wrapping so that when the rocket moves off one side of the screen, it reappears on the opposite side:
# If the rocket moves off the right side of the screen, it should reappear on the left.
# If it moves off the left side of the screen, it should reappear on the right.
# Similarly, when the rocket moves off the top of the screen, it should reappear at the bottom, and vice versa.
# You'll need four if statements (two for horizontal wrapping and two for vertical wrapping) to handle this.

# Additional Notes:
# Utilize the turtle.tracer() function to prevent Turtle from updating the screen until turtle.update() is called. This will smooth the movement of the rocket.
# Debugging Tip: While debugging, you can comment out the tracer() function to see the changes on the screen as they happen.

# Submission:
# Attach your Python .py file to Blackboard.
# Make sure to include comments 

#==========================================================================================================================================================================================================#

# import turtle library
from turtle import *

# Set global variables X and Y, and the screen size (height and width)
X, Y = 0, 0
screen_width, screen_height = 400, 400

# Initialize the turtle with screen size and hide the tracer and turtle (smoother drawing)
setup(screen_width, screen_height)
tracer(0)
hideturtle()

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
    update()  # Update the screen after drawing

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

# Set turtle to listen for keyboard input and use onKey to trace keystrokes
listen()
onkey(moveup, "Up")
onkey(movedown, "Down")
onkey(moveleft, "Left")
onkey(moveright, "Right")

# Main game loop, initial drawing of the rocket
drawrocket()

# Keep the window open until the user closes it
done()