extends Control

var image
var lastFocusedButton = null

enum States{MAIN, LEVELS, OPTIONS}

var current_state = States.MAIN

# Called when the node enters the scene tree for the first time.
func _ready():
	if InputHandler.hasController():
		$VBoxContainer/PlayButton.grab_focus()
		lastFocusedButton = $VBoxContainer/PlayButton
	image = $BackgroundImage
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$BackButton.visible = false

	Events.connect("go_to_previous_screen", backFromOptions)

func _process(delta):

	match current_state:
		States.MAIN:
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if lastFocusedButton.visible == true:
					lastFocusedButton.grab_focus()
				elif $VBoxContainer/PlayButton.visible == true:
					$VBoxContainer/PlayButton.grab_focus()
					lastFocusedButton = $VBoxContainer/PlayButton

		States.LEVELS:
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $VBoxContainer2/HBoxContainer/Level1Button.visible == true:
					$VBoxContainer2/HBoxContainer/Level1Button.grab_focus()


		States.OPTIONS:
			pass

	if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
		get_viewport().gui_get_focus_owner().emit_signal("pressed")


func _on_play_button_pressed():
	lastFocusedButton = $VBoxContainer/PlayButton
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true
	$BackButton.visible = true
	#Events.emit_signal("go_to_level_select")
	current_state = States.LEVELS


func _on_options_button_pressed():
	lastFocusedButton = $VBoxContainer/OptionsButton
	Events.emit_signal("go_to_options")
	current_state = States.OPTIONS

func _on_credits_button_pressed():
	pass
	#lastFocusedButton = get_viewport().gui_get_focus_owner()
	#Events.emit_signal("go_to_credits")


func _on_exit_button_pressed():
	get_tree().quit()

func backFromOptions():
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$BackButton.visible = false
	current_state = States.MAIN


func _on_back_button_pressed():
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$BackButton.visible = false
	current_state = States.MAIN

func _on_level_1_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_1")


func _on_level_2_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_2")


func _on_level_3_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_3")


func _on_level_4_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_1")


func _on_level_5_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_2")

func _on_level_6_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_3")
