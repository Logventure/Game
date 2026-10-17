extends Control

enum States{DISABLED, COMPLETED}
var current_state = States.DISABLED

@export var nextlvl_label : Label
var nextlvl_text_key = "NEXTLVL" 
var fullversion_text_key = "FULLVERSION" 
@export var fullversion_menu : FullVersionMenu
var is_end_of_demo = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	nextlvl_label.text = nextlvl_text_key
	Events.completed_last_demo_level.connect(on_is_last_demo_level)

func _process(delta):
	match current_state:
		States.DISABLED:
			visible = false
		States.COMPLETED:
			visible = true		
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() != $Panel/VBoxContainer/NextLevelButton and get_viewport().gui_get_focus_owner() != $Panel/VBoxContainer/ExitButton and !fullversion_menu.visible:
				if $Panel/VBoxContainer/NextLevelButton.visible == true:
					$Panel/VBoxContainer/NextLevelButton.grab_focus()
			if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
					get_viewport().gui_get_focus_owner().emit_signal("pressed")


func _on_exit_button_pressed():
	Utils.playUISound(self, -6)
	Events.emit_signal("go_to_main_menu")

func resetFocusedButton():
	current_state = States.COMPLETED
	if InputHandler.hasController():
		$Panel/VBoxContainer/NextLevelButton.grab_focus()
	Events.emit_signal("new_level_completed")

func _on_next_level_button_pressed():
	Utils.playUISound(self, -6)
	if is_end_of_demo:
		fullversion_menu.set_visibility(true)
		return
	current_state = States.DISABLED
	visible = false
	Events.emit_signal("go_to_next_level")

func on_is_last_demo_level():
	is_end_of_demo = true
	nextlvl_label.text = fullversion_text_key
