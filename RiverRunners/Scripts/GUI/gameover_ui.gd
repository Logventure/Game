extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if InputHandler.hasController():
		$VBoxContainer/StoryButton.grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
		get_viewport().gui_get_focus_owner().emit_signal("pressed")


func _on_give_up_button_pressed():
	Events.emit_signal("go_to_main_menu")

func _on_retry_button_pressed():
	visible = false
	Events.emit_signal("go_to_level", "infinite_level_id")