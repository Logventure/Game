extends Node


var max_age = 0.02

var resuming_delay = 0.0

var last_input = ""
var last_input_age = max_age

enum InputType {KBM, CONTROLLER, TOUCHSCREEN}

enum GameState {RUNNING, PAUSED, RESUMING}
var current_game_state = GameState.RUNNING

var input_type = InputType.KBM

func _ready():
	Events.connect("on_dialog_start", onGamePause)
	Events.connect("on_dialog_end", onGameResume)

	Events.connect("pause_game", onGamePause)
	Events.connect("resume_game", onGameResume)

func _process(delta):
	match current_game_state:
		GameState.RUNNING:
			last_input_age += delta
			handleKeyboardInput()

		GameState.PAUSED:
			last_input_age = max_age + 1

		GameState.RESUMING:
			if resuming_delay > max_age:
				current_game_state = GameState.RUNNING
			else:
				resuming_delay += delta


func onGamePause():
	current_game_state = GameState.PAUSED

func onGameResume():
	current_game_state = GameState.RESUMING
	resuming_delay = 0.0

func handleKeyboardInput():
	if Input.is_action_just_pressed("pause"):
		Events.emit_signal("pause_game")

	
	
func handleControllerInput():
	pass
	
func getCommands():
	match current_game_state:
		GameState.RUNNING:
			var kbcommands = getKeyboardCommands()
			if kbcommands != []:
				input_type = InputType.KBM
			var ctrlcommands = getControllerCommands()
			if ctrlcommands != []:
				input_type = InputType.CONTROLLER

			kbcommands.append_array(ctrlcommands)

			return kbcommands

		GameState.PAUSED:
			return []

		GameState.RESUMING:	
			return []
	
func getKeyboardCommands():
	var commands = []
	if Input.is_action_just_pressed("dashRight"):
		commands.append("dash_right")

	if Input.is_action_just_pressed("dashLeft"):
		commands.append("dash_left")

	if Input.is_action_just_pressed("dashFront"):
		commands.append("dash_front")

	if Input.is_action_pressed("left"):
			commands.append("move_left")

	if Input.is_action_pressed("right"):
			commands.append("move_right")

	if Input.is_action_just_pressed("jump"):
		commands.append("jump")

	if Input.is_action_just_pressed("throw"):
		commands.append("throw")

	if Input.is_action_just_pressed("shield"):
		commands.append("shield")

	if commands.has("move_left") and commands.has("move_right") or commands.has("dash_left") or commands.has("dash_right"):
		if commands.find("move_left") >= 0:
			commands.remove_at(commands.find("move_left"))
		if commands.find("move_right") >= 0:
			commands.remove_at(commands.find("move_right"))

	if commands.has("dash_left") and commands.has("dash_right"):
		if commands.find("dash_left") >= 0:
			commands.remove_at(commands.find("dash_left"))
		if commands.find("dash_right") >= 0:
			commands.remove_at(commands.find("dash_right"))


	if commands != []:
		last_input = commands[len(commands)-1]
		last_input_age = 0.0
		return commands
	else:
		return []

func getLastInput():
	if last_input_age < max_age:
		return last_input
	else:
		return ""

func clearLastInput():
	last_input_age += max_age

func getControllerCommands():
	var commands = []
	if Input.is_action_just_pressed("controller_dashRight"):
		commands.append("dash_right")

	elif Input.is_action_just_pressed("controller_dashLeft"):
		commands.append("dash_left")

	else:
		if Input.is_action_pressed("controller_left"):
			commands.append("move_left")

		elif Input.is_action_pressed("controller_right"):
			commands.append("move_right")

	if Input.is_action_just_pressed("controller_jump"):
		commands.append("jump")

	if Input.is_action_just_pressed("controller_throw"):
		commands.append("throw")

	if Input.is_action_just_pressed("controller_shield"):
		commands.append("shield")

	if commands != []:
		if commands.find("jump") > commands.find("throw"):
			last_input = "jump"
			last_input_age = 0.0
		elif commands.find("jump") < commands.find("throw"):
			last_input = "throw"
			last_input_age = 0.0
		else:
			clearLastInput()
		return commands
	else:
		return []

func hasController():
	return len(Input.get_connected_joypads()) > 0

func lastInputType():
	match input_type:
		InputType.KBM:
			return "kbm"
		InputType.CONTROLLER:
			return "controller"
		InputType.TOUCHSCREEN:
			return "touchscreen"