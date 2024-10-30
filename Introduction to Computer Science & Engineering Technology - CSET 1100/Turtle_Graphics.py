# Aiden Rader
# 09/09/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Turtle Graphics

#===========================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Use turtle graphics and Python to create a graphical landscape. 
# 1) The bottom half of the screen should be green.
# 2) The top half of the screen should be blue.
# 3) Draw grey mountains in the background using triangles.  Create at least 3 mountains of varying sizes.
# 4) Draw an orange truck with black tires in the foreground.
# 5) Draw your initials in the bottom right corner. (MAKE SURE TO USE ACTUAL DRAWING AND NOT TEXT)
# 6) Include these instructions as comments at the beginning of your program.  Also comment each section, i.e. draw mountain, draw truck, etc.

# Attach your .py file to Blackboard.  Make sure you attach your .py file and not the .pyproj file.  If you attach the wrong file you will get zero credit.

#===========================================================================================================================================================#

# Import turtle library into script
import turtle

# Create a Turtle object and set its defualt speed
t = turtle.Turtle()
t.speed(10)

# Set screen object
window = turtle.Screen()

# Set the Turtle windows Title, Screensize and default Background Color (White - optional)
window.title('Turtle Graphics Assignment - Aiden Rader')
window.screensize(500,500)
window.bgcolor("white")

# Lift pen before drawing
t.penup()

# Draw the blue sky
t.goto(-500,500)
t.pendown()
t.begin_fill()
t.fillcolor("blue")
t.forward(1000)
t.right(90)
t.forward(650)
t.right(90)
t.forward(1000)
t.right(90)
t.forward(650)
t.right(90)
t.end_fill()

# Lift pen after drawing first square
t.penup()

# Draw the green ground
t.goto(-500,-150)
t.pendown()
t.begin_fill()
t.fillcolor("green")
t.forward(1000)
t.right(90)
t.forward(650)
t.right(90)
t.forward(1000)
t.right(90)
t.forward(650)
t.right(90)
t.end_fill()

# Lift pen after drawing second square
t.penup()

# Draw the grey mountains of varying sizes #

# Draw the first (smallest) mountain
t.goto(-400, -150)
t.pendown()
t.begin_fill()
t.fillcolor("grey")
t.forward(200)
t.left(120)
t.forward(200)
t.left(120)
t.forward(200)
t.left(120)
t.end_fill()

# Lift pen after drawing first mountain
t.penup()

# Draw the second (medium) mountain 
t.goto(175, -150)
t.pendown()
t.begin_fill()
t.fillcolor("grey")
t.forward(300)
t.left(120)
t.forward(300)
t.left(120)
t.forward(300)
t.left(120)
t.end_fill()

# Lift pen after drawing second mountain
t.penup()

# Draw the third (largest) mountain
t.goto(-250, -150)
t.pendown()
t.begin_fill()
t.fillcolor("grey")
t.forward(400)
t.left(120)
t.forward(400)
t.left(120)
t.forward(400)
t.left(120)
t.end_fill()

# Lift pen after drawing third mountain
t.penup()

# Draw the orange truck with black wheels #

# Draw the truck body (Rectangle)
t.goto(-200, -130)
t.pendown()
t.begin_fill()
t.fillcolor("orange")
t.setheading(0)  # This faces the turtle to the right
t.forward(150)
t.left(90)
t.forward(50)
t.left(90)
t.forward(150)
t.left(90)
t.forward(50)
t.left(90)
t.end_fill()

# Lift pen after drawing truck body
t.penup()

# Draw the truck cabin (Square)
t.goto(-110, -80)
t.pendown()
t.begin_fill()
t.fillcolor("orange")
t.setheading(0)
t.forward(50)
t.left(90)
t.forward(50)
t.left(90)
t.forward(50)
t.left(90)
t.forward(50)
t.left(90)
t.end_fill()

# Lift pen after drawing truck cabin
t.penup()

# Draw a cabin window on the truck (Small Square)
t.goto(-100, -70)
t.pendown()
t.begin_fill()
t.fillcolor("LightGrey")
t.setheading(0)
t.forward(30)
t.left(90)
t.forward(30)
t.left(90)
t.forward(30)
t.left(90)
t.forward(30)
t.left(90)
t.end_fill()

# Lift pen after drawing truck cabin
t.penup()

# Draw the black wheels for the orange truck #

# First (Rear) wheel
t.goto(-175, -150)
t.pendown()
t.begin_fill()
t.fillcolor("black")
t.circle(20)
t.end_fill()

# Lift pen after drawing First (Rear) wheel
t.penup()

# Second (Front) wheel
t.goto(-75, -150)
t.pendown()
t.begin_fill()
t.fillcolor("black")
t.circle(20)
t.end_fill()

# Lift pen after finishing drawing of the truck
t.penup()


# Draw initials "AR" in the bottom right corner #

# Attempt to draw a black letter "A"
t.goto(220, -350)
t.pensize(10)
t.pencolor("black")
t.pendown()
t.forward(110)
t.right(65)
t.forward(50)
t.backward(180)
t.right(50)
t.forward(180)
t.setheading(0)

# Lift pen after drawing letter 'A'
t.penup()

# Attempt to draw a black letter "R"
t.goto(380, -350)
t.pensize(10)
t.pencolor("black")
t.pendown()
t.circle(60, 180)
t.left(90)
t.forward(170)
t.backward(50)
t.left(35)
t.forward(60)

# Show the turtle window on code execution
t.showturtle()

# Hide the turtle and finish
t.hideturtle()
turtle.exitonclick() # Keep the window open (keep for debugging purposes)