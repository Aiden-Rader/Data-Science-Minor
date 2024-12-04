
# Aiden Rader
# 12/03/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Tie Fighter Game

#==========================================================================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Description: In this Python Turtle Graphics-based game, you are tasked with shooting down a Tie Fighter from the Star Wars universe, which will be maneuvering randomly against a vibrant backdrop of stars and planets. Control an aiming reticle with the arrow keys to target and shoot the Tie Fighter using the space-bar. The game tracks your hits, and achieving three successful strikes on the Tie Fighter will prompt a game over screen, asking if you wish to play again.

# Game Mechanics:
# Tie Fighter: The Tie Fighter will be a graphical object that randomly moves across a celestial canvas filled with stars and the occasional passing planet. Use Turtle Graphics to draw and animate the Tie Fighter, ensuring it remains within the visible galaxy (screen boundaries).
# Background: Use Turtle graphics to draw stars and planets in the background (5 stars, 1 planet) based on your previous assignment.
# Reticle: The reticle, designed as a circle with crosshairs, is controlled using the arrow keys (up, down, left, right) for aiming.
# Shooting: Pressing the space-bar fires a red laser from the reticle's position. Implement this using four lines that converge on the reticle's center to simulate the laser blast.
# Hit Detection: Calculate if a laser hit is successful by checking if the center of the reticle aligns with the center of the Tie Fighter using the formula D=(xf​−xr​)**2+(yf​−yr​)**2​.
# Scoring: Track the number of times the Tie Fighter is hit. Three successful hits conclude the gameplay, displaying "Game Over" prominently against the starry background.
# Game Over: The game prompts the player if they want to replay upon achieving three hits or by pressing the escape key.

# Additional Tips:
# Base your game mechanics on the provided square animation tutorial, incorporating onkeypress and onkeyrelease functions from the Turtle module.
# Maintain global coordinates for both the Tie Fighter and the reticle (xf, yf, xr, yr).
# Use the random library for the Tie Fighter's unpredictable movements.
# Draw the background, then the fighter, then the reticle, and lastly, the lasers.
# Organize your code using functions or classes to enhance modularity and maintainability.
# This immersive space battle experience not only tests your aiming skills but also places you right in the middle of an interstellar conflict against the backdrop of a dynamically rendered universe.

#==========================================================================================================================================================================================================#

from turtle import *
import random
import math

# Screen setup
screen = Screen()
screen.title("Tie Fighter Game")
screen.bgcolor("black")
screen.setup(width=600, height=400)
screen.tracer(0)

# Global Game variables
RETICLE_SPEED = 15
TIE_FIGHTER_SPEED = 500
hits = 0
game_playing = True

# INITAL RENDERS #

# Reticle setup, this acts as the core element of the reticle (inital load)
reticle = Turtle()
reticle.shape("circle")
reticle.color("green")
reticle.penup()
reticle.goto(0, 0)

# Crosshairs setup
crosshairs = Turtle()
crosshairs.hideturtle()
crosshairs.speed(0)
crosshairs.color("gray")
crosshairs.penup()

# Tie Fighter setup, also acts as the core element of the tie fighter (inital load)
tie_fighter = Turtle()
tie_fighter.shape("square")
tie_fighter.color("light gray")
tie_fighter.penup()
tie_fighter.goto(random.randint(-280, 280), random.randint(-180, 180))

# Laser setup (render but keep hidden until laser is fired)
laser = Turtle()
laser.hideturtle()
laser.color("red")
laser.penup()

# Hit Counter, displays the number of hits in top right corner of screen! (This was just a little fun experiement)
hit_counter = Turtle()
hit_counter.hideturtle()
hit_counter.color("white")
hit_counter.penup()
hit_counter.goto(250, 170)

# Game Over message (render element but keep hidden until game over)
game_over_message = Turtle()
game_over_message.hideturtle()
game_over_message.color("red")
game_over_message.penup()

# Initialize the background, reticle, and crosshairs
def initialize_game(reload):
	if (reload == False):
		draw_background()

	update_hit_counter()
	draw_reticle()
	move_tie_fighter()

# Draw background elements (i.e. 5 stars and 1 planet)
def draw_background():
	# Draw the stars
	for _ in range(5):
		stars = Turtle()
		stars.hideturtle()
		stars.color("white")
		stars.penup()
		stars.goto(random.randint(-280, 280), random.randint(-180, 180))
		stars.pendown()

		# Sets the star oritentation at random rotated axises
		stars.setheading(random.randint(0, 360))

		# Loop for each line of the 5-point star
		for _ in range(5):
			stars.forward(8)
			stars.right(144)
		stars.penup()

	# Draw the planet
	planet = Turtle()
	planet.hideturtle()
	planet.penup()
	planet.goto(random.randint(-280, 280), random.randint(-180, 180))
	planet.pendown()
	planet.color("blue")
	planet.begin_fill()
	planet.circle(25)
	planet.end_fill()

# Reticle drawing, update function to update the reticle based on position and redraws crosshairs
def draw_reticle():
	# Clear previous crosshair drawing for no duped crosshairs
	crosshairs.clear()

	# Draw the circle
	crosshairs.goto(reticle.xcor(), reticle.ycor() - 15)
	crosshairs.pendown()
	crosshairs.circle(15)
	crosshairs.penup()

	# Draw horizontal crosshair
	crosshairs.goto(reticle.xcor() - 15, reticle.ycor())
	crosshairs.pendown()
	crosshairs.goto(reticle.xcor() + 15, reticle.ycor())
	crosshairs.penup()

	# Draw vertical crosshair
	crosshairs.goto(reticle.xcor(), reticle.ycor() - 15)
	crosshairs.pendown()
	crosshairs.goto(reticle.xcor(), reticle.ycor() + 15)
	crosshairs.penup()

# Function to update the hit counter text (only did this out of fun and it helps!)
def update_hit_counter():
	hit_counter.clear()
	hit_counter.write(f'Hits: {hits}', align='center', font=('Arial',16, 'bold'))

# Movement controls for the reticle,
# NOTE: instead of using xf, yf, xr, yr we can actually use setx and sety (and xcor and ycor) for the tie fighter and the reticle!
def move_up():
	if game_playing:
		reticle.sety(min(reticle.ycor() + RETICLE_SPEED, 190))
		draw_reticle()
		screen.update()

def move_down():
	if game_playing:
		reticle.sety(max(reticle.ycor() - RETICLE_SPEED, -190))
		draw_reticle()
		screen.update()

def move_left():
	if game_playing:
		reticle.setx(max(reticle.xcor() - RETICLE_SPEED, -290))
		draw_reticle()
		screen.update()

def move_right():
	if game_playing:
		reticle.setx(min(reticle.xcor() + RETICLE_SPEED, 290))
		draw_reticle()
		screen.update()

# Fire laser function
def fire_laser():
	global hits
	if not game_playing:
		return
	laser.clear()
	laser.goto(reticle.xcor(), reticle.ycor())
	laser.pendown()
	laser.goto(tie_fighter.xcor(), tie_fighter.ycor())
	laser.penup()

	screen.ontimer(laser.clear, 100)

	# Calculate distance D=(xf−xr)**2+(yf−yr)**2 (DONT FORGET TO SQUARE IT FOR MORE PRECISION)
	distance = math.sqrt((tie_fighter.xcor() - reticle.xcor())**2 + (tie_fighter.ycor() - reticle.ycor())**2)

	# If the distance is in a very small hit box than we can count it as a hit
	if distance <= 30:
		hits += 1
		update_hit_counter()
		tie_fighter.goto(random.randint(-280, 280), random.randint(-180, 180))
	if hits == 3:
		end_game()

# Tie Fighter movement
def move_tie_fighter():
	if game_playing:
		# Randomly selects a number between thresholds for x and y movements
		x_move = random.choice([-30, 30])
		y_move = random.choice([-30, 30])
		tie_fighter.setx(max(min(tie_fighter.xcor() + x_move, 280), -280))
		tie_fighter.sety(max(min(tie_fighter.ycor() + y_move, 180), -180))

		# Timer for adjusting tie fighter "speed" using global const
		screen.ontimer(move_tie_fighter, TIE_FIGHTER_SPEED)

# End game function, handles all hiding and clearing elements
def end_game():
	global game_playing

	# Set up the 'r' keybinding to restart the game
	screen.onkeypress(restart, 'r')

	# Set game_playing to False to prevent movement and laser firing
	game_playing = False

	# Hide the reticle, crosshairs, and tie fighter
	reticle.hideturtle()
	crosshairs.hideturtle()
	tie_fighter.hideturtle()

	# Clear the hit counter, laser, and any remaining crosshairs
	crosshairs.clear()
	hit_counter.clear()
	laser.clear()

	# Display the game over message
	game_over_message.goto(0, 0)
	game_over_message.write("GAME OVER! Press ESC to quit or 'r' to restart!", align="center", font=("Arial", 16, "bold"))

# Restart game
def restart():
	global hits, game_playing

	# Removes the 'r' keybinding until it is set again
	screen.onkeypress(None, 'r')

	# Reset hit counter and set game_playing flag to true to let player use controls again
	hits = 0
	game_playing = True

	# Show reticle, tie fighterm and clear game over message
	reticle.showturtle()
	tie_fighter.showturtle()
	game_over_message.clear()

	# Does not reload background but everything else reloads
	initialize_game(reload=True)

# Constant key bindings
screen.listen()
screen.onkeypress(move_up, "Up")
screen.onkeypress(move_down, "Down")
screen.onkeypress(move_left, "Left")
screen.onkeypress(move_right, "Right")
screen.onkeypress(fire_laser, "space")
screen.onkeypress(screen.bye, "Escape")

# Call init function
initialize_game(reload=False)

# Game loop
while True:
	screen.update()