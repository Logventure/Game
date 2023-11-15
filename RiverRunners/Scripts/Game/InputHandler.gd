extends Node


var max_age = 0.03

var last_input = ""
var last_input_age = max_age

enum InputType {KBM, CONTROLLER, TOUCHSCREEN}

var input_type = InputType.KBM

func _process(delta):
	last_input_age += delta
	handleKeyboardInput()

func handleKeyboardInput():
	#if Input.is_action_just_pressed("dashRight"):
	#	Events.emit_signal("input_dash_right")
	#	print("dash r")
	#elif Input.is_action_just_pressed("dashLeft"):
	#	Events.emit_signal("input_dash_left")
	#	print("dash l")
	#elif Input.is_action_pressed("left"):
	#	Events.emit_signal("input_move_left")
	#	print("left")
	#elif Input.is_action_pressed("right"):
	#	Events.emit_signal("input_move_right")
	#	print("right")
	#elif Input.is_action_just_pressed("jump"):
	#	Events.emit_signal("input_jump")
	#	print("jump")
	#elif Input.is_action_just_pressed("throw"):
	#	Events.emit_signal("input_throw")
	#	print("throw")
	#elif Input.is_action_just_pressed("shield"):
	#	Events.emit_signal("input_shield")
	#	print("shield")
	if Input.is_action_just_pressed("pause"):
		Events.emit_signal("pause_game")
	
func handleControllerInput():
	pass
	
func getCommands():
	var kbcommands = getKeyboardCommands()
	if kbcommands != []:
		input_type = InputType.KBM
	var ctrlcommands = getControllerCommands()
	if ctrlcommands != []:
		input_type = InputType.CONTROLLER

	kbcommands.append_array(ctrlcommands)

	return kbcommands
	
func getKeyboardCommands():
	var commands = []
	if Input.is_action_just_pressed("dashRight"):
		commands.append("dash_right")

	elif Input.is_action_just_pressed("dashLeft"):
		commands.append("dash_left")

	else:
		if Input.is_action_pressed("left"):
			commands.append("move_left")

		elif Input.is_action_pressed("right"):
			commands.append("move_right")

	if Input.is_action_just_pressed("jump"):
		commands.append("jump")

	if Input.is_action_just_pressed("throw"):
		commands.append("throw")

	if Input.is_action_just_pressed("shield"):
		commands.append("shield")

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
	print("Clear last input")

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
		clearLastInput()
		return commands
	else:
		return []
