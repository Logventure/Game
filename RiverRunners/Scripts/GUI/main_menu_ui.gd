extends Control

var image

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/PlayButton.grab_focus()
	image = $BackgroundImage

func _on_play_button_pressed():
	var modes = load("res://GameComponents/GUI/modes_ui.tscn")
	get_tree().change_scene_to_packed(modes)
	#get_tree().change_scene_to_file("res://Game/GameManager.tscn")

func _on_options_button_pressed():
	var options = load("res://GameComponents/GUI/options_ui.tscn")
	get_tree().change_scene_to_packed(options)

func _on_exit_button_pressed():
	get_tree().quit()


func _on_credit_button_pressed(): #criar scene para os creditos
	pass # Replace with function body.
