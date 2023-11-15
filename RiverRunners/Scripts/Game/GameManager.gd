extends Node2D

@onready var viewer = $Viewer

enum States {MAIN_MENU, OPTIONS, MODE_SELECT, LEVEL_SELECT, LEVEL, LOADING_SCREEN}

var current_state = States.MAIN_MENU
var target_state = States.MAIN_MENU 

var current_screen
var target_screen


# Called when the node enters the scene tree for the first time.
func _ready():

	Events.connect("go_to_main_menu", switchToMainMenu)
	Events.connect("go_to_options", switchToOptions)
	Events.connect("go_to_mode_select", switchToModeSelect)
	Events.connect("go_to_level_select", switchToLevelSelect)
	Events.connect("go_to_level", switchToLevel)

	switchToMainMenu()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		States.MAIN_MENU:
			pass

		States.OPTIONS:
			pass

		States.MODE_SELECT:
			pass

		States.LEVEL_SELECT:
			pass
	
		States.LEVEL:
			pass

		States.LOADING_SCREEN:
			pass

	print(current_state)
	print(current_screen)
	print("children: ", get_children())
	print("viewer children: ", viewer.get_children())

	
func switchToMainMenu():
	target_state = States.MAIN_MENU
	target_screen = loadScene("res://GameComponents/GUI/main_menu_ui.tscn")
	replaceScreen(viewer, target_screen)

		
func switchToOptions():
	target_state = States.OPTIONS
	target_screen = loadScene("res://GameComponents/GUI/options_ui.tscn")
	replaceScreen(viewer, target_screen)

func switchToModeSelect():
	target_state = States.LEVEL_SELECT
	target_screen = loadScene("res://GameComponents/GUI/modes_ui.tscn")
	replaceScreen(viewer, target_screen)

func switchToLevelSelect():
	target_state = States.LEVEL_SELECT
	target_screen = loadScene("res://GameComponents/GUI/levels_ui.tscn")
	replaceScreen(viewer, target_screen)


func switchToLevel(level_id: String):
	target_state = States.LEVEL
	target_screen = loadScene("res://Levels/LevelTemplate.tscn")
	replaceScreen(viewer, target_screen)

func loadScene(path: String):
	var scene = load(path)
	return scene.instantiate()

func replaceScreen(parent: Node, new_screen: Node):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
	parent.add_child(new_screen)
	current_screen = new_screen
	current_state = target_state