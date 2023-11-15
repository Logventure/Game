extends Control

var image

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/PlayButton.grab_focus()
	image = $BackgroundImage

func _on_play_button_pressed():
	Events.emit_signal("go_to_mode_select")

func _on_options_button_pressed():
	Events.emit_signal("go_to_options")

func _on_exit_button_pressed():
	get_tree().quit()


func _on_credit_button_pressed(): #criar scene para os creditos
	pass # Replace with function body.
