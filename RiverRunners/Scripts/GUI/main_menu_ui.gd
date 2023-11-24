extends Control

var image

# Called when the node enters the scene tree for the first time.
func _ready():
	if InputHandler.hasController():
		$VBoxContainer/StoryButton.grab_focus()
	image = $BackgroundImage

func _process(delta):
	if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
		get_viewport().gui_get_focus_owner().emit_signal("pressed")

func _on_story_button_pressed():
	Events.emit_signal("go_to_level_select")

func _on_infinite_button_pressed():
	Events.emit_signal("go_to_level", "infinite_level_id")

func _on_options_button_pressed():
	Events.emit_signal("go_to_options")

func _on_exit_button_pressed():
	get_tree().quit()


