extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_back_button_pressed():
	var back_options = load("res://GameComponents/GUI/options_ui.tscn")
	get_tree().change_scene_to_packed(back_options)
