extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_back_button_pressed():
	Events.emit_signal("go_to_mode_select")