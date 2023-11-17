extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("camera_status", onUpdateCameraStatus)

func _on_back_button_pressed():
	Events.emit_signal("go_to_previous_screen")

func _on_audio_button_pressed():
	var audio = load("res://GameComponents/GUI/audio_ui.tscn")
	get_tree().change_scene_to_packed(audio)

func _on_video_button_pressed():
	var video = load("res://GameComponents/GUI/video_ui.tscn")
	get_tree().change_scene_to_packed(video)


func onUpdateCameraStatus(pos,zoom): #so that the menu shows up when entered mid level
	var temp_solution = Vector2(pos.x - 1920/2, pos.y - 1080/2) #temporary solution
	position = temp_solution