extends Control

var image

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()
	image = $BackgroundImage

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Game/GameManager.tscn")

func _on_levels_button_pressed():
	var levels = load("res://GameComponents/GUI/levels_ui.tscn")
	get_tree().change_scene_to_packed(levels)

func _on_options_button_pressed():
	var options = load("res://GameComponents/GUI/options_ui.tscn")
	get_tree().change_scene_to_packed(options)

func _on_exit_button_pressed():
	get_tree().quit()
