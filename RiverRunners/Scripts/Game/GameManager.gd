extends Node2D

@onready var viewer = $Viewer

const FILE_MANAGEMENT_SCRIPT = preload("res://Scripts/FileManagement.gd")

enum States {MAIN_MENU, OPTIONS, MODE_SELECT, LEVEL_SELECT, LEVEL, LOADING_SCREEN}

var current_state = States.MAIN_MENU
var target_state = States.MAIN_MENU 

var current_screen
var target_screen

var previous_state = States.MAIN_MENU
var previous_screen

var last_level = 0
var level_ids = ["level_justin", "level_frog", "level_salmon", "level_crab", "level_otter", "level_shork", "level_infinite"]
var level_ids_easy = ["level_justin_easy", "level_frog_easy", "level_salmon_easy", "level_crab_easy", "level_otter_easy", "level_shork_easy", "level_infinite"]
var level_ids_hard = ["level_justin_hard", "level_frog_hard", "level_salmon_hard", "level_crab_hard", "level_otter_hard", "level_shork_hard", "level_infinite"]

var level_list = level_ids

# Called when the node enters the scene tree for the first time.
func _ready():

	FILE_MANAGEMENT_SCRIPT.loadConfig()
	setSound()

	Events.connect("go_to_main_menu", switchToMainMenu)
	Events.connect("go_to_options", switchToOptions)
	Events.connect("go_to_mode_select", switchToModeSelect)
	Events.connect("go_to_level_select", switchToLevelSelect)
	Events.connect("go_to_level", switchToLevel)
	Events.connect("go_to_next_level", switchToNextLevel)
	Events.connect("go_to_previous_screen", switchToPreviousScreen)
	Events.connect("go_to_credits", switchToCredits)
	Events.connect("level_completed", levelCompleted)

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


	
func switchToMainMenu():
	target_state = States.MAIN_MENU
	target_screen = loadScene("res://GameComponents/GUI/main_menu_ui.tscn")
	replaceScreen(viewer, target_screen)
	Events.emit_signal("changeMusic","MENU")

func switchToCredits():
	switchToMainMenu()
	if current_screen.has_method("_on_credits_button_pressed"):
		current_screen._on_credits_button_pressed()
		
func switchToOptions():
	previous_state = current_state
	previous_screen = current_screen
	target_state = States.OPTIONS
	target_screen = loadScene("res://GameComponents/GUI/options_ui.tscn")
	showTemporaryScreen(viewer, target_screen)

func switchToModeSelect():
	target_state = States.LEVEL_SELECT
	target_screen = loadScene("res://GameComponents/GUI/modes_ui.tscn")
	replaceScreen(viewer, target_screen)

func switchToLevelSelect():
	var difficulty = FILE_MANAGEMENT_SCRIPT.loadDifficulty()
	if difficulty == 0:
		level_list = level_ids_easy
	if difficulty == 1:
		level_list = level_ids
	if difficulty == 2:
		level_list = level_ids_hard

	target_state = States.LEVEL_SELECT
	target_screen = loadScene("res://GameComponents/GUI/levels_ui.tscn")
	replaceScreen(viewer, target_screen)


func switchToLevel(level_id: int):
	var difficulty = FILE_MANAGEMENT_SCRIPT.loadDifficulty()
	if difficulty == 0:
		level_list = level_ids_easy
	if difficulty == 1:
		level_list = level_ids
	if difficulty == 2:
		level_list = level_ids_hard
	if difficulty > 2:
		level_list = level_ids

	target_state = States.LEVEL
	target_screen = loadScene("res://Levels/LevelTemplate.tscn")
	if level_id < 0 or level_id >= len(level_list):
		var last_level_id = level_list[last_level]
		target_screen.setLevelScript(last_level_id)
	else:
		last_level = level_id
		var last_level_id = level_list[last_level]
		target_screen.setLevelScript(last_level_id)

	if level_id >= 0 and level_id < 3:
		Events.emit_signal("changeMusic","EASY")
	elif level_id >= 3 and level_id < 5:
		Events.emit_signal("changeMusic","MEDIUM")
	elif level_id == 5:
		Events.emit_signal("changeMusic","HARD")
	elif level_id > 5:
		Events.emit_signal("changeMusic","INFINITE")

	if target_screen.has_method("setRelaxMode"):
		if difficulty > 2:
			target_screen.setRelaxMode(true)
		else:
			target_screen.setRelaxMode(false)

	replaceScreen(viewer, target_screen)
	Events.emit_signal("start_score")


func switchToNextLevel():
	target_state = States.LEVEL
	target_screen = loadScene("res://Levels/LevelTemplate.tscn")
	var last_level_id = level_list[last_level]

	if last_level >= 0 and last_level < 3:
		Events.emit_signal("changeMusic","EASY")
	elif last_level >= 3 and last_level < 5:
		Events.emit_signal("changeMusic","MEDIUM")
	elif last_level == 5:
		Events.emit_signal("changeMusic","HARD")
	elif last_level > 5:
		Events.emit_signal("changeMusic","INFINITE")

	var difficulty = FILE_MANAGEMENT_SCRIPT.loadDifficulty()
	if target_screen.has_method("setRelaxMode"):
		if difficulty > 2:
			target_screen.setRelaxMode(true)
		else:
			target_screen.setRelaxMode(false)


	target_screen.setLevelScript(last_level_id)
	replaceScreen(viewer, target_screen)

func levelCompleted():
	if last_level + 1 < len(level_ids):
		last_level += 1
	var savedLevel = FILE_MANAGEMENT_SCRIPT.loadLevels()
	if savedLevel == null:
		savedLevel = 0
	if last_level > savedLevel and last_level < len(level_ids):
		FILE_MANAGEMENT_SCRIPT.saveLevels(last_level)

func switchToPreviousScreen():
	if previous_screen != null:
		returnFromTemporaryScreen(viewer, current_screen)

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

func showTemporaryScreen(parent: Node, temp_screen: Node):
	for child in parent.get_children():
		child.visible = false
	parent.add_child(temp_screen)
	temp_screen.visible = true
	current_screen = temp_screen
	current_state = target_state

func returnFromTemporaryScreen(parent: Node, temp_screen: Node):
	parent.remove_child(temp_screen)
	temp_screen.queue_free()
	current_screen = previous_screen
	current_state = previous_state
	for child in parent.get_children():
		child.visible = true

func setSound():
	var soundsArray = FILE_MANAGEMENT_SCRIPT.loadSounds() # 0 -> Master, 1 -> Sound, 2 -> Music, 3 -> Ambience
	
	var i = 0
	while i != 4:
		if soundsArray != null:
			if soundsArray[i] != null:
				match i:
					0:
						AudioServer.set_bus_volume_db(0, linear_to_db(soundsArray[i]))
					1:
						AudioServer.set_bus_volume_db(2, linear_to_db(soundsArray[i]))
					2:
						AudioServer.set_bus_volume_db(3, linear_to_db(soundsArray[i]))
					3:	
						AudioServer.set_bus_volume_db(1, linear_to_db(soundsArray[i]))
			else:
				match i:
					0:
						AudioServer.set_bus_volume_db(0, linear_to_db(0.5))
					1:
						AudioServer.set_bus_volume_db(2, linear_to_db(0.5))
					2:
						AudioServer.set_bus_volume_db(3, linear_to_db(0.5))
					3:	
						AudioServer.set_bus_volume_db(1, linear_to_db(0.5))
		else:
			match i:
				0:
					AudioServer.set_bus_volume_db(0, linear_to_db(0.5))
				1:
					AudioServer.set_bus_volume_db(2, linear_to_db(0.5))
				2:
					AudioServer.set_bus_volume_db(3, linear_to_db(0.5))
				3:	
					AudioServer.set_bus_volume_db(1, linear_to_db(0.5))
		i +=1
