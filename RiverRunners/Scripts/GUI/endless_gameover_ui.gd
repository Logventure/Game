extends Control

enum States{DISABLED, GAMEOVER}
var current_state = States.DISABLED

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _process(delta):
	match current_state:
		States.DISABLED:
			visible = false
		States.GAMEOVER:
			visible = true		
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() != $Panel/VBoxContainer/RetryButton and get_viewport().gui_get_focus_owner() != $Panel/VBoxContainer/GiveUpButton:
				if $Panel/VBoxContainer/RetryButton.visible == true:
					$Panel/VBoxContainer/RetryButton.grab_focus()
			if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
					get_viewport().gui_get_focus_owner().emit_signal("pressed")


func _on_give_up_button_pressed():
	Utils.playUISound(self, -6)
	Events.emit_signal("go_to_main_menu")

func _on_retry_button_pressed():
	Utils.playUISound(self, -6)
	current_state = States.DISABLED
	visible = false
	Events.emit_signal("go_to_level", -1)

func resetFocusedButton():
	current_state = States.GAMEOVER
	if InputHandler.hasController():
		$Panel/VBoxContainer/RetryButton.grab_focus()

func highest_score(points):
	$Label.text = str(points)