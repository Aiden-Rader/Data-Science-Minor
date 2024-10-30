# Aiden Rader
# 09/30/2024
# Langenderfer, Robert
# Intro to CSET
# Assignment: Adventure Game

#===========================================================================================================================================================#

# BLACKBOARD INSTRUCTIONS #

# Programming Assignment: Adventure Game in "To Le Do"

# Objective:
# 
# Develop a text-based adventure game in Python set in the fantastical land of "To Le Do." Your game will feature a choice between two paths: becoming a Wizard or a Knight. Each path involves selecting from a list of three options, with only one path leading to success. This assignment tests your ability to use programming concepts such as variables, user input, if statements, loops, lists, and error checking to handle invalid inputs.
# Assignment Details:
# Game Introduction:
# Begin your game by welcoming the player to "To Le Do," and describe this wondrous land in your own words.
# Path Selection:
# Prompt the player to choose their path: Wizard or Knight. Use a list to store the paths and retrieve the player's choice.
# 
# Wizard Path:
# - The player seeks the ancient tome that holds the secrets of the universe.  

# Choices:
# 
# Use a list to manage these choices.
# 1. "Search the Ancient Library: You spend years among the tomes, but the book is nowhere to be found. Your quest ends in wisdom, but not victory."
# 2. "Explore the Forbidden Cave: The cave is treacherous and full of traps. Unfortunately, you do not make it out alive."
# 3. "Venture into the Enchanted Forest: Within the heart of the Enchanted Forest, you find the ancient tome. Your quest is a success! The secrets of the universe are yours."
# 
# Knight Path:
# - The player vows to defeat the dragon terrorizing "To Le Do" for centuries.  

# Choices:
# 
# Use a list to manage these choices.
# 1. "Attack in the Dragon's Lair: You fight valiantly in the dragon's lair, but it's too strong in its home territory. You fall in battle, remembered as a hero."
# 2. "Challenge to a Duel: The dragon accepts your challenge but proves too powerful in combat. The kingdom mourns its brave knight."
# 3. "Seek the help of a Sorcerer: With the help of a sorcerer, you weaken the dragon and defeat it in battle. The kingdom is saved, and you are hailed as its greatest hero."
#
# Error Checking:
# Implement loops around the input sections to ensure that players can only proceed with valid choices from the lists. If an invalid option is entered, the game should inform the player and prompt them to choose again. The program should ignore case.
# Implementation Guidelines: 
# - Describe the land of To Le Do in your own words at the beginning of the program.
# - Prompt the user for inputs, using lists to store the choices (listed in bold) and retrieve them based on user input.
# - Use if statements to direct the flow of the game based on the player's choices.
# - Include nested if statements within each main path to handle the subsequent choices from the list.
# - Apply while loops to validate user inputs, ensuring the game continues to prompt for a decision until a valid choice is made (choices are listed in bold above)
# - Store player inputs in variables and use these to determine the game's outcome.
# - Provide clear and concise feedback for each choice, mirroring the exact text provided above for each outcome.
# - Use only programming techniques already covered in class.
# - Support upper and lower case options by converting the input to lower case.
# - The code must be completely your own work, not from Chegg, ChatGPT, nor your friend. If you need help, ask during the lab.
# 
# Example Code Structure:
# print("Welcome to 'To Le Do'!")
# # describe the land of "To Le Do" here in your own words.
# paths=["wizard", "knight"]
# choice=input("Choose your path (Wizard/Knight): ").lower()
# while choice not in paths:
#     print("Invalid choice. Please choose again.")
#     choice =input("Choose your path (Wizard/Knight): ").lower()
# if choice == "wizard":
#     # Wizard path with list of choices and nested if and while for error checking
# elif choice == "knight":
#     # Knight path with list of choices and nested if and while for error checking

# At the end of the game, ask the user if they would like to play again. If yes, start the game again; otherwise, exit the program.
# Requirements:
# - Submit a Python script (.py file) to Blackboard that runs the adventure game from start to finish.
# - Ensure your script includes the instructions as comments and comments explaining major sections and logic used in the game in your own words.
# - Test your game to ensure all paths work as expected and that invalid inputs are handled gracefully.
# - You must store the user options in a list.
# This assignment will help you practice control structures in Python, including decision-making with if statements, looping with while, and using lists and input validation to create an engaging text-based game.

#===========================================================================================================================================================#

# GLOBAL VARIABLE(S)
play_again = "yes" # Start the game with "yes" to trigger the loop

# Condition to start the game once again or for the first time
while play_again == "yes":

    # Print statments are meant to introduce the world to the player
    print("Welcome to the mystical land of To Le Do!")
    print("")
    print("In To Le Do, brave adventurers can choose between two paths: becoming a powerful Wizard or a courageous Knight.")
    print("Each path is filled with challenges; only the wisest or strongest will succeed.")
    print("Will you become a master of magic and enchantments, or will you defeat the dragon terrorizing the land?")
    print("")

    # Make a list to store the playable paths, game is dependent on these
    story_paths = ["wizard", "knight"]

    # Ask the user to choose a path
    user_choice = input("Choose your path (Wizard/Knight): ").lower()

    # Keep asking until the user enters a valid general path choice, form of error handling
    while user_choice not in story_paths:
        print("Invalid choice. Please choose again.")
        user_choice = input("Choose your path (Wizard/Knight): ").lower()

    # If the player chooses the Wizard Path
    if user_choice == "wizard":
        print("As a Wizard, the player will seek the ancient tome that holds the secrets of the universe!")

        wizard_choices = ["1", "2", "3"] # This will be our validator for which option we pick, approach is easier then putting whole string into list and indexing...
        print("What will be your choice? Will you: ")

        # Print the players options while playing as the wizard
        print("1. Search the Ancient Library")
        print("2. Explore the Forbidden Cave")
        print("3. Venture into the Enchanted Forest")
        w_choice = input("Choose your next path (1, 2, or 3): ")
        print("")

        # Again, keep asking until the user enters a valid wizard path choice (1, 2, or 3), form of error handling
        while w_choice not in wizard_choices:
            print("Invalid choice, please choose valid choice")
            w_choice = input("Choose your next path (1, 2, or 3): ")
            print("")

        # if statements for user input for wizard path choice
        if w_choice == "1":
            print("You spend years among the tomes, but the book is nowhere to be found. Your quest ends in wisdom, but not victory.")
        elif w_choice == "2":
            print("The cave is treacherous and full of traps. Unfortunately, you do not make it out alive.")
        elif w_choice == "3":
            print("Within the heart of the Enchanted Forest, you find the ancient tome. Your quest is a success! The secrets of the universe are yours.")

    # If the player chooses the Knight Path
    elif user_choice == "knight":
        print("As a Knight, the player vows to defeat the dragon terrorizing To Le Do for centuries.")

        knight_choices = ["1", "2", "3"] # Again, this will be a validator of sorts
        print("What will be your choice? Will you: ")

        # Print the players options while playing as the knight
        print("1. Attack in the Dragon's Lair")
        print("2. Challenge to a Duel")
        print("3. Seek the help of a Sorcerer")
        k_choice = input("Choose your next path (1, 2, or 3): ")
        print("")

        # Again, keep asking until the user enters a valid knight path choice (1, 2, or 3), form of error handling
        while k_choice not in knight_choices:
            print("Invalid choice, please choose valid choice")
            k_choice = input("Choose your next path (1, 2, or 3): ")
            print("")

        # if statements for user input for knights path choice
        if k_choice == "1":
            print("You fight valiantly in the dragon's lair, but it's too strong in its home territory. You fall in battle, remembered as a hero.")
        elif k_choice == "2":
            print("The dragon accepts your challenge but proves too powerful in combat. The kingdom mourns its brave knight.")
        elif k_choice == "3":
            print("With the help of a sorcerer, you weaken the dragon and defeat it in battle. The kingdom is saved, and you are hailed as its greatest hero.")

    print("")
    # Ask if they want to play again
    play_again = input("Do you want to play again? (yes/no): ").lower()
    
    # List for yes/no functionality
    boolean_list = ["yes", "no"]
    
    # If yes or no is NOT in the boolean list var, play until one is
    while play_again not in boolean_list:
        print("Invalid input. Please enter 'yes' or 'no'.")
        play_again = input("Do you want to play again? (yes/no): ").lower()

    # if yes, give visual cue that the game is reloading then restart the while loop, 
    # if no then farewall message appears we break out of while loop and end the program
    if play_again == "yes":
        print("")
        print("--------|RELOADING|--------")
        print("")
    elif play_again == "no":
        print("")
        print("Thank you for playing my short story game, farewell!")
        print("")
        break