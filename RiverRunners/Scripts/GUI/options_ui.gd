extends Control

const FILE_MANAGEMENT_SCRIPT = preload("res://Scripts/FileManagement.gd")
const TEXT_FONT = preload("res://Assets/UI/Fonts/pixeloid-font/PixeloidSansBold-PKnYd.ttf")
var ls = LabelSettings.new()
var isInInputOverrideMode = false
var overridingAction = ""
var keyboardActions = ["dashLeft", "dashRight", "jump", "throw", "shield"]
var controllerActions = ["controller_dashLeft", "controller_dashRight", "controller_jump", "controller_throw", "controller_shield"]
enum States {GENERAL, AUDIO, CONTROLS}
var current_state = States.GENERAL

var active = true
var showDifficulty = true

var easy_mode_button_normal_image = load("res://Assets/UI/Options Menu/Button-Easy.png")
var easy_mode_button_hover_image = load("res://Assets/UI/Options Menu/Button-Easy-Disabled.png")
var normal_mode_button_normal_image = load("res://Assets/UI/Options Menu/Button-Normal.png")
var normal_mode_button_hover_image = load("res://Assets/UI/Options Menu/Button-Normal-Disabled.png")
var hard_mode_button_normal_image = load("res://Assets/UI/Options Menu/Button-Hard.png")
var hard_mode_button_hover_image = load("res://Assets/UI/Options Menu/Button-Hard-Disabled.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("camera_status", onUpdateCameraStatus)
	$Panel/ButtonContainer/GeneralButton.grab_focus()
	$Panel/General.visible = true
	$Panel/Fullscreen.visible = true
	$Panel/Windowed.visible = true
	initializeFont()
	makeLabels()
	redoControllsButtons()

	_on_general_button_pressed()
	default_mode()
	
func _process(delta):
	if active:
		if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
			if $BackButton.visible == true:
				$BackButton.grab_focus()
		if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
			if get_viewport().gui_get_focus_owner().has_signal("pressed"):
				get_viewport().gui_get_focus_owner().emit_signal("pressed")	
	
	match current_state:
		States.GENERAL:
			pass

		States.AUDIO:
			pass

		States.CONTROLS:
			pass

func setActive(value):
	active = value

func resetFocus():
	$Panel/ButtonContainer/GeneralButton.grab_focus()
	_on_general_button_pressed()

func _on_back_button_pressed():
	Utils.playUISound(self, -6)
	Events.emit_signal("go_to_previous_screen")


func _on_audio_button_pressed():
	Utils.playUISound(self, -6)
	current_state = States.AUDIO

	audio_button_clicked()	

func _on_general_button_pressed():
	Utils.playUISound(self, -6)
	current_state = States.GENERAL

	general_button_clicked()

func _on_controls_button_pressed():
	Utils.playUISound(self, -6)
	current_state = States.CONTROLS

	controls_button_clicked()

func audio_button_clicked():
	$"Panel/Master Volume".visible = true	
	$"Panel/Sound Volume".visible = true
	$"Panel/Music Volume".visible = true
	$"Panel/Ambience Volume".visible = true
	$Panel/Audio.visible = true

	$Panel/General.visible = false
	$Panel/Fullscreen.visible = false
	$Panel/Windowed.visible = false
	if showDifficulty:
		$Panel/Difficulty.visible = false
		$Panel/ButtonContainer1.visible = false

	$Panel/Action.visible = false
	$Panel/Keyboard.visible = false
	$Panel/Controller.visible = false

	$Panel/ButtonContainer/GeneralButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Audio/HBoxContainer/CenterContainer/HSlider.get_path())
	$Panel/ButtonContainer/AudioButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Audio/HBoxContainer/CenterContainer/HSlider.get_path())
	$Panel/ButtonContainer/ControlsButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Audio/HBoxContainer/CenterContainer/HSlider.get_path())

func general_button_clicked():
	$Panel/General.visible = true
	$Panel/Fullscreen.visible = true
	$Panel/Windowed.visible = true
	if showDifficulty:
		$Panel/Difficulty.visible = true
		$Panel/ButtonContainer1.visible = true

	$"Panel/Master Volume".visible = false	
	$"Panel/Sound Volume".visible = false
	$"Panel/Music Volume".visible = false
	$"Panel/Ambience Volume".visible = false
	$Panel/Audio.visible = false

	$Panel/Action.visible = false
	$Panel/Keyboard.visible = false
	$Panel/Controller.visible = false

	$Panel/ButtonContainer/GeneralButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/General/HBoxContainer1/FullscreenButton.get_path())
	$Panel/ButtonContainer/AudioButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/General/HBoxContainer1/FullscreenButton.get_path())
	$Panel/ButtonContainer/ControlsButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/General/HBoxContainer1/FullscreenButton.get_path())

func controls_button_clicked():
	$Panel/Action.visible = true
	$Panel/Keyboard.visible = true
	$Panel/Controller.visible = true

	$Panel/General.visible = false
	$Panel/Fullscreen.visible = false
	$Panel/Windowed.visible = false
	if showDifficulty:
		$Panel/Difficulty.visible = false
		$Panel/ButtonContainer1.visible = false

	$"Panel/Master Volume".visible = false	
	$"Panel/Sound Volume".visible = false
	$"Panel/Music Volume".visible = false
	$"Panel/Ambience Volume".visible = false
	$Panel/Audio.visible = false

	$Panel/ButtonContainer/GeneralButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Keyboard/dashLeftButton.get_path())
	$Panel/ButtonContainer/AudioButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Keyboard/dashLeftButton.get_path())
	$Panel/ButtonContainer/ControlsButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Controller/controller_dashLeftButton.get_path())

func onUpdateCameraStatus(pos,zoom): #so that the menu shows up when entered mid level
	var temp_solution = Vector2(pos.x - 1920/2, pos.y - 1080/2) #temporary solution
	#position = temp_solution
	#var scale_value = 0.8/zoom.x
	#scale = Vector2(scale_value,scale_value)


func _on_borderless_button_pressed():
	Utils.playUISound(self, -6)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_fullscreen_button_pressed():
	Utils.playUISound(self, -6)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_actionButton_pressed(action):
	Utils.playUISound(self, -6)
	$Panel3.visible = false
	$Panel2.visible = true
	isInInputOverrideMode = true
	overridingAction = str(action)

func getActionButtonName(action):
	return str(action)+"Button"

func getLabelName(action):
	return str(action)+"Label"

func getMouseButtonText(index):
	if (index == 1):
		return "Left Click"
		
	if (index == 2):
		return "Right Click"

	if (index == 3):
		return "Middle Click"	
	
	assert(false)

func initializeFont():
	ls.set_font(TEXT_FONT)

func makeLabels():
	var labels = ["Dash Left", "Dash Right", "Jump", "Throw", "Shield"]
	for labelIndex in range(0, 5):
		var labelPosY = 37 + labelIndex*37
		var label = labels[labelIndex]

		var newLabel = Label.new()
		newLabel.set_name(getLabelName(label))
		newLabel.text = label
		newLabel.position.y = labelPosY
		newLabel.label_settings = ls

		$Panel/Action.add_child(newLabel)

func redoControllsButtons():
	for child in $Panel/Keyboard.get_children():
		child.queue_free()
	for child in $Panel/Controller.get_children():
		child.queue_free()
		
	var selectedActions = ["dashLeft", "dashRight", "jump", "throw", "shield", "controller_dashLeft", "controller_dashRight", "controller_jump", "controller_throw", "controller_shield"]

	var buttons = Array()

	for keyboardActionIndex in range(0, selectedActions.size()/2):
		var keyboardActionPosY = 33 + keyboardActionIndex*37
		var keyboardAction = selectedActions[keyboardActionIndex]

		var action_event = InputMap.action_get_events(selectedActions[keyboardActionIndex])[0]	
		var keyString = ""
		if action_event is InputEventMouse:
				keyString = getMouseButtonText(action_event.get_button_index())
		else:
			var keyCode = action_event.physical_keycode
			keyString = OS.get_keycode_string(keyCode)
	
		var newKeyboardActionButton = Button.new()
		newKeyboardActionButton.set_name(getActionButtonName(keyboardAction))
		newKeyboardActionButton.text = keyString
		newKeyboardActionButton.position.y = keyboardActionPosY
		newKeyboardActionButton.flat = true
		newKeyboardActionButton.set("custom_fonts/font", ls)
		buttons.push_back(newKeyboardActionButton)

		$Panel/Keyboard.add_child(newKeyboardActionButton)

		get_node("Panel/Keyboard/" + newKeyboardActionButton.name).connect("pressed", _on_actionButton_pressed.bind(keyboardAction))


	for controllerActionIndex in range(selectedActions.size()/2, selectedActions.size()):
		var controllerActionPosY = 33 + (controllerActionIndex-5)*37
		var controllerAction = selectedActions[controllerActionIndex]

		var action_event = InputMap.action_get_events(selectedActions[controllerActionIndex])[0]
		var keyString = ""
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

		var newControllerActionButton = Button.new()
		newControllerActionButton.set_name(getActionButtonName(controllerAction))
		newControllerActionButton.text = keyString
		newControllerActionButton.position.y = controllerActionPosY
		newControllerActionButton.flat = true
		newControllerActionButton.set("custom_fonts/font", ls)
		buttons.push_back(newControllerActionButton)

		$Panel/Controller.add_child(newControllerActionButton)
		
		get_node("Panel/Controller/" + newControllerActionButton.name).connect("pressed", _on_actionButton_pressed.bind(controllerAction))

		$Panel/ButtonContainer/ControlsButton.set_focus_neighbor(SIDE_BOTTOM, buttons[0].get_path())


	for buttonIndex in range(0, buttons.size()):
		var selectedButton = buttons[buttonIndex]
		match buttonIndex:
			0:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/ButtonContainer/ControlsButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_RIGHT, $Panel/Controller/controller_dashLeftButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Keyboard/dashRightButton.get_path())
			1:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Keyboard/dashLeftButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_RIGHT, $Panel/Controller/controller_dashRightButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Keyboard/jumpButton.get_path())
			2:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Keyboard/dashRightButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_RIGHT, $Panel/Controller/controller_jumpButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Keyboard/throwButton.get_path())
			3:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Keyboard/jumpButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_RIGHT, $Panel/Controller/controller_throwButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Keyboard/shieldButton.get_path())
			4:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Keyboard/throwButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_RIGHT, $Panel/Controller/controller_shieldButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $BackButton.get_path())
			5:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/ButtonContainer/ControlsButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_LEFT, $Panel/Keyboard/dashLeftButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Controller/controller_dashRightButton.get_path())
			6:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Controller/controller_dashLeftButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_LEFT, $Panel/Keyboard/dashRightButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Controller/controller_jumpButton.get_path())
			7:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Controller/controller_dashRightButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_LEFT, $Panel/Keyboard/jumpButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Controller/controller_throwButton.get_path())
			8:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Controller/controller_jumpButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_LEFT, $Panel/Keyboard/throwButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $Panel/Controller/controller_shieldButton.get_path())
			9:
				selectedButton.set_focus_neighbor(SIDE_TOP, $Panel/Controller/controller_throwButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_LEFT, $Panel/Keyboard/shieldButton.get_path())
				selectedButton.set_focus_neighbor(SIDE_BOTTOM, $BackButton.get_path())

func _input(event):
	var validInput = false
	var has_action = false
	var buttonNode = ""
	var buttonText = ""
	if isInInputOverrideMode:
		if event is InputEventKey: # maybe nao permitir certas teclas?
			if event.pressed and !overridingAction.contains("controller"):
				#check if it already exists on another action
				for action in keyboardActions:
					if InputMap.action_has_event(action, event):
						has_action = true
						break
				if !has_action:
					validInput = true
					buttonNode = "Panel/Keyboard/" + getActionButtonName(overridingAction)
					var keyCode = event.physical_keycode
					buttonText = OS.get_keycode_string(keyCode)
					for oldEvent in InputMap.action_get_events(overridingAction):
						if oldEvent is InputEventKey or InputEventMouseButton:
							InputMap.action_erase_event(overridingAction, oldEvent)
							break
					InputMap.action_add_event(overridingAction, event)
				else:
					$Panel3.visible = true
			else:
				$Panel2.visible = false
		elif event is InputEventMouseButton:
			if event.pressed and !overridingAction.contains("controller"):
				for action in keyboardActions:
					if InputMap.action_has_event(action, event):
						has_action = true
						break
				if !has_action:
					validInput = true
					buttonNode = "Panel/Keyboard/" + getActionButtonName(overridingAction)
					buttonText = getMouseButtonText(event.get_button_index())
					for oldEvent in InputMap.action_get_events(overridingAction):
						if oldEvent is InputEventMouseButton or InputEventKey:
							InputMap.action_erase_event(overridingAction, oldEvent)
							break
					InputMap.action_add_event(overridingAction, event)
				else:
					$Panel3.visible = true
			else:
				$Panel2.visible = false
		elif event is InputEventJoypadButton:
			if (event.button_index >= 0 and event.button_index <= 3 and overridingAction.contains("controller")) or (event.button_index >= 7 and event.button_index <= 10 and overridingAction.contains("controller")):
				for action in controllerActions:
					if InputMap.action_has_event(action, event):
						has_action = true
						break
				if !has_action:
					validInput = true
					buttonNode = "Panel/Controller/" + getActionButtonName(overridingAction)
					if event.button_index == 0:
						buttonText = "Cross"
					elif event.button_index == 1:
						buttonText = "Circle"
					elif event.button_index == 2:
						buttonText = "Square"
					elif event.button_index == 3:
						buttonText = "Triangle"
					elif event.button_index == 7:
						buttonText = "L3"
					elif event.button_index == 8:
						buttonText = "R3"
					elif event.button_index == 9:
						buttonText = "L1"
					elif event.button_index == 10:
						buttonText = "R1"
					for oldEvent in InputMap.action_get_events(overridingAction):
						if oldEvent is InputEventJoypadButton or InputEventJoypadMotion:
							InputMap.action_erase_event(overridingAction, oldEvent)
							break
					InputMap.action_add_event(overridingAction, event)
				else:
					$Panel3.visible = true
			else:
				$Panel2.visible = false
		elif event is InputEventJoypadMotion:
			if (event.axis == 4 and  overridingAction.contains("controller")) or (event.axis == 5 and overridingAction.contains("controller")):
				for action in controllerActions:
					if InputMap.action_has_event(action, event):
						has_action = true
						break
				if !has_action:
					validInput = true
					buttonNode = "Panel/Controller/" + getActionButtonName(overridingAction)
					if event.axis == 4:
						buttonText = "L2"
					elif event.axis == 5:
						buttonText = "R2"
					for oldEvent in InputMap.action_get_events(overridingAction):
						if oldEvent is InputEventJoypadMotion or InputEventJoypadButton:
							InputMap.action_erase_event(overridingAction, oldEvent)
							break
					InputMap.action_add_event(overridingAction, event)
				else:
					$Panel3.visible = true
			else:
				$Panel2.visible = false
		if validInput:
			$Panel2.visible = false
			$Panel3.visible = false
			get_viewport().set_input_as_handled()
			get_node(buttonNode).text = buttonText
			isInInputOverrideMode = false
			overridingAction = ""
			FILE_MANAGEMENT_SCRIPT.saveConfig()
			FILE_MANAGEMENT_SCRIPT.loadConfig()



func _on_hard_mode_button_pressed():
	Utils.playUISound(self, -6)
	FILE_MANAGEMENT_SCRIPT.saveDifficulty(2)

	$Panel/ButtonContainer1/HardModeButton.texture_normal = hard_mode_button_normal_image
	$Panel/ButtonContainer1/EasyModeButton.texture_normal = easy_mode_button_hover_image
	$Panel/ButtonContainer1/NormalModeButton.texture_normal = normal_mode_button_hover_image

func _on_normal_mode_button_pressed():
	Utils.playUISound(self, -6)
	FILE_MANAGEMENT_SCRIPT.saveDifficulty(1)

	$Panel/ButtonContainer1/NormalModeButton.texture_normal = normal_mode_button_normal_image
	$Panel/ButtonContainer1/EasyModeButton.texture_normal = easy_mode_button_hover_image
	$Panel/ButtonContainer1/HardModeButton.texture_normal = hard_mode_button_hover_image

func _on_easy_mode_button_pressed():
	Utils.playUISound(self, -6)
	FILE_MANAGEMENT_SCRIPT.saveDifficulty(0)

	$Panel/ButtonContainer1/EasyModeButton.texture_normal = easy_mode_button_normal_image
	$Panel/ButtonContainer1/NormalModeButton.texture_normal = normal_mode_button_hover_image
	$Panel/ButtonContainer1/HardModeButton.texture_normal = hard_mode_button_hover_image

func default_mode():
	var difficulty_mode = FILE_MANAGEMENT_SCRIPT.loadDifficulty() #0 is easy, 1 is normal and 2 is hard

	if difficulty_mode == null:
		difficulty_mode = 1

	if difficulty_mode == 0:
		$Panel/ButtonContainer1/EasyModeButton.texture_normal = easy_mode_button_normal_image
		$Panel/ButtonContainer1/NormalModeButton.texture_normal = normal_mode_button_hover_image
		$Panel/ButtonContainer1/HardModeButton.texture_normal = hard_mode_button_hover_image
	elif difficulty_mode == 1:
		$Panel/ButtonContainer1/NormalModeButton.texture_normal = normal_mode_button_normal_image
		$Panel/ButtonContainer1/EasyModeButton.texture_normal = easy_mode_button_hover_image
		$Panel/ButtonContainer1/HardModeButton.texture_normal = hard_mode_button_hover_image
	elif difficulty_mode == 2:
		$Panel/ButtonContainer1/HardModeButton.texture_normal = hard_mode_button_normal_image
		$Panel/ButtonContainer1/EasyModeButton.texture_normal = easy_mode_button_hover_image
		$Panel/ButtonContainer1/NormalModeButton.texture_normal = normal_mode_button_hover_image

	elif difficulty_mode > 2:
		$Panel/ButtonContainer1/EasyModeButton.texture_normal = easy_mode_button_hover_image
		$Panel/ButtonContainer1/NormalModeButton.texture_normal = normal_mode_button_hover_image
		$Panel/ButtonContainer1/HardModeButton.texture_normal = hard_mode_button_hover_image