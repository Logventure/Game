extends Control

enum States{DISABLED, PAUSED, OPTIONS}
var current_state = States.DISABLED

@onready var options_difficulty = $OptionsUI/Panel/Difficulty
@onready var options_mode_buttons = $OptionsUI/Panel/ButtonContainer1

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("go_to_previous_screen", onBackFromOptions)

	options_difficulty.visible = false
	options_mode_buttons.visible = false
	$OptionsUI.showDifficulty = false


func _process(delta):
	match current_state:
		States.DISABLED:
			$Panel.visible = false
			$OptionsUI.visible = false
			$OptionsUI.setActive(false)
		States.PAUSED:
			$OptionsUI.setActive(false)
			$Panel.visible = true
			$OptionsUI.visible = false
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $Panel/VBoxContainer/ResumeButton.visible == true:
					$Panel/VBoxContainer/ResumeButton.grab_focus()
			if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
					get_viewport().gui_get_focus_owner().emit_signal("pressed")

		States.OPTIONS:
			$Panel.visible = false
			$OptionsUI.visible = true
			$OptionsUI.setActive(true)
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $OptionsUI/Panel/ButtonContainer/GeneralButton.visible == true:
					$OptionsUI/Panel/ButtonContainer/GeneralButton.grab_focus()
			if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
					get_viewport().gui_get_focus_owner().emit_signal("pressed")

func _on_options_button_pressed():
	current_state = States.OPTIONS
	$Panel.visible = false
	$OptionsUI.visible = true
	if $OptionsUI/Panel/ButtonContainer/GeneralButton.visible == true:
		$OptionsUI/Panel/ButtonContainer/GeneralButton.grab_focus()
	#Events.emit_signal("go_to_options")
	$OptionsUI.resetFocus()

func onBackFromOptions():
	current_state = States.PAUSED

func _on_resume_button_pressed():
	current_state = States.DISABLED
	$Panel.visible = false
	$OptionsUI.visible = false
	Events.emit_signal("resume_game")

func _on_give_up_button_pressed():
	current_state = States.DISABLED
	Events.emit_signal("go_to_main_menu")

func resetFocusedButton():
	current_state = States.PAUSED
	if InputHandler.hasController():
		$Panel/VBoxContainer/ResumeButton.grab_focus()
