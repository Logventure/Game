extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_back_button_pressed():
	var back_main_menu = load("res://GameComponents/GUI/main_menu_ui.tscn")
	get_tree().change_scene_to_packed(back_main_menu)