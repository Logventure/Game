extends Control

enum States{DISABLED, COMPLETED}
var current_state = States.DISABLED

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _process(delta):
	match current_state:
		States.DISABLED:
			visible = false
		States.COMPLETED:
			visible = true		
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() != $Panel/VBoxContainer/NextLevelButton and get_viewport().gui_get_focus_owner() != $Panel/VBoxContainer/GiveUpButton:
				if $Panel/VBoxContainer/NextLevelButton.visible == true:
					$Panel/VBoxContainer/NextLevelButton.grab_focus()
			if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
					get_viewport().gui_get_focus_owner().emit_signal("pressed")


func _on_give_up_button_pressed():
	Events.emit_signal("go_to_main_menu")

func resetFocusedButton():
	current_state = States.COMPLETED
	if InputHandler.hasController():
		$Panel/VBoxContainer/NextLevelButton.grab_focus()


func _on_next_level_button_pressed():
	current_state = States.DISABLED
	visible = false
	Events.emit_signal("go_to_next_level")
