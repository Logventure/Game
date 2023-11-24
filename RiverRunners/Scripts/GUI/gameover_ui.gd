extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_give_up_button_pressed():
	Events.emit_signal("go_to_main_menu")

func _on_retry_button_pressed():
	visible = false
	Events.emit_signal("go_to_level", "infinite_level_id")