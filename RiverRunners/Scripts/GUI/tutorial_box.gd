extends Node2D

var actionToWaitFor = ""
var time = 0
var completed = false
var baseposition

var wait_time = 0

enum States {HIDDEN, VISIBLE, COMPLETED}
var current_state = States.HIDDEN

# Called when the node enters the scene tree for the first time.
func _ready():
	baseposition = position

	Events.connect("jump_dive",onDive)


func setText(ability: String):
	var key = ""
	var action = ""
	actionToWaitFor = ability
	match ability:
		"move_left":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_left")[0]
				key = getKeyString(action_event, true)
				key = "JOYSTICK"
			else:
				var action_event = InputMap.action_get_events("left")[0]
				key = getKeyString(action_event, false)
			
			action = "go LEFT"

		"move_right":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_right")[0]
				key = getKeyString(action_event, true)
				key = "JOYSTICK"
			else:
				var action_event = InputMap.action_get_events("right")[0]
				key = getKeyString(action_event, false)
			
			action = "go RIGHT"

		"jump":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_jump")[0]
				key = getKeyString(action_event, true)
			else:
				var action_event = InputMap.action_get_events("jump")[0]
				key = getKeyString(action_event, false)
			
			action = "JUMP"

		"dash_left":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_dashLeft")[0]
				key = getKeyString(action_event, true)
			else:
				var action_event = InputMap.action_get_events("dashLeft")[0]
				key = getKeyString(action_event, false)
			
			action = "DASH LEFT"
			
		"dash_right":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_dashRight")[0]
				key = getKeyString(action_event, true)
			else:
				var action_event = InputMap.action_get_events("dashRight")[0]
				key = getKeyString(action_event, false)
			
			action = "DASH RIGHT"

		"shield":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_shield")[0]
				key = getKeyString(action_event, true)
			else:
				var action_event = InputMap.action_get_events("shield")[0]
				key = getKeyString(action_event, false)
			

			key = key
			action = "DESTROY rocks"
			
		"throw":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_throw")[0]
				key = getKeyString(action_event, true)
			else:
				var action_event = InputMap.action_get_events("throw")[0]
				key = getKeyString(action_event, false)
			
			action = "THROW a stone"

		"dive":
			if InputHandler.hasController():
				var action_event = InputMap.action_get_events("controller_jump")[0]
				key = getKeyString(action_event, true)
			else:
				var action_event = InputMap.action_get_events("jump")[0]
				key = getKeyString(action_event, false)

			key = key + " while on air"
			action = "FALL"
		

	$Label.text = "Press " + key + " to " + action
	if key == "JOYSTICK":
		$Label.text = "Move " + key + " to " + action

	current_state = States.VISIBLE
	wait_time = 0


func getKeyString(action_event, iscontroller = false):
	var keyString = ""
	if iscontroller:
		if action_event is InputEventJoypadMotion:
			if action_event.axis == 4:
				keyString = "L2"
			elif action_event.axis == 5:
				keyString = "R2"
		elif action_event is InputEventJoypadButton:
			if action_event.button_index == 0:
				keyString = "Cross"
			elif action_event.button_index == 1:
				keyString = "Circle"
			elif action_event.button_index == 2:
				keyString = "Square"
			elif action_event.button_index == 3:
				keyString = "Triangle"
			elif action_event.button_index == 7:
				keyString = "L3"
			elif action_event.button_index == 8:
				keyString = "R3"
			elif action_event.button_index == 9:
				keyString = "L1"
			elif action_event.button_index == 10:
				keyString = "R1"

	else:
		if action_event is InputEventMouse:
			if (action_event.get_button_index() == 1):
				keyString = "Left Click"
			if (action_event.get_button_index() == 2):
				keyString = "Right Click"
			if (action_event.get_button_index() == 3):
				keyString = "Middle Click"	
		else:
			var keyCode = action_event.physical_keycode
			keyString = OS.get_keycode_string(keyCode)


	return keyString


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	match current_state:
		States.HIDDEN:
			modulate.a = 0
			time = 0

		States.VISIBLE:
			time += delta
			wait_time += delta

			var y = 30 + time*-60
			if y < 0:
				y = 0
			position = Vector2(baseposition.x,baseposition.y + y)
			var alpha = time*2
			if alpha > 1:
				alpha = 1
			modulate.a = alpha

			if time > 1:
				var commands = InputHandler.getCommands()
				if commands.find(actionToWaitFor) != -1 or wait_time > 20:
					current_state = States.COMPLETED
					time = 0
					Utils.playSoundFile(self,"res://Assets/Audio/SFX/tutorial_success.wav","SFX",0,true)
		
			

		States.COMPLETED:
			time += delta
			position = Vector2(baseposition.x,baseposition.y + time*60)
			var alpha = 1 - time*2
			if alpha < 0:
				alpha = 0
			modulate.a = alpha


func onDive():
	if current_state == States.VISIBLE and time > 1 and actionToWaitFor == "dive":
		current_state = States.COMPLETED
		time = 0
		Utils.playSoundFile(self,"res://Assets/Audio/SFX/tutorial_success.wav","SFX",0,true)