extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if InputHandler.hasController():
		$Panel/VBoxContainer/ResumeButton.grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
		get_viewport().gui_get_focus_owner().emit_signal("pressed")


#get_tree().quit()

func _on_options_button_pressed():
	Events.emit_signal("go_to_options")

func _on_resume_button_pressed():
	visible = false
	Events.emit_signal("resume_game")

func _on_give_up_button_pressed():
	Events.emit_signal("go_to_main_menu")

func resetFocusedButton():
	if InputHandler.hasController():
		$Panel/VBoxContainer/ResumeButton.grab_focus()
