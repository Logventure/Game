extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#get_tree().quit()

func _on_options_button_pressed():
	Events.emit_signal("go_to_options")

func _on_resume_button_pressed():
	visible = false
	Events.emit_signal("resume_game")

func _on_give_up_button_pressed():
	Events.emit_signal("go_to_main_menu")