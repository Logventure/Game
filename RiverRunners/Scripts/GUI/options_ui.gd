extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_back_button_pressed():
	Events.emit_signal("go_to_main_menu")

func _on_audio_button_pressed():
	var audio = load("res://GameComponents/GUI/audio_ui.tscn")
	get_tree().change_scene_to_packed(audio)

func _on_video_button_pressed():
	var video = load("res://GameComponents/GUI/video_ui.tscn")
	get_tree().change_scene_to_packed(video)