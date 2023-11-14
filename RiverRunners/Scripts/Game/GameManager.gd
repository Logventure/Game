extends Node2D

enum States {MAIN_MENU, OPTIONS, LEVEL_SELECT, LEVEL, LOADING_SCREEN}

var current_state = States.MAIN_MENU

var target_state = States.MAIN_MENU 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		States.MAIN_MENU:
			pass

		States.OPTIONS:
			pass

		States.LEVEL_SELECT:
			pass
	
		States.LEVEL:
			pass

		States.LOADING_SCREEN:
			pass
	
func switchToMainMenu():
	current_state = States.MAIN_MENU


func switchToLevelSelect():
	current_state = States.LEVEL_SELECT
		