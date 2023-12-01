extends Control

var image
var lastFocusedButton = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if InputHandler.hasController():
		$VBoxContainer/StoryButton.grab_focus()
		lastFocusedButton = $VBoxContainer/StoryButton
	image = $BackgroundImage
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$BackButton.visible = false

func _process(delta):
	if Input.is_action_just_pressed("confirm") and not get_viewport().gui_get_focus_owner() == null:
		get_viewport().gui_get_focus_owner().emit_signal("pressed")


func _on_play_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true
	$BackButton.visible = true
	#Events.emit_signal("go_to_level_select")


func _on_options_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_options")

func _on_credits_button_pressed():
	pass
	#lastFocusedButton = get_viewport().gui_get_focus_owner()
	#Events.emit_signal("go_to_credits")


func _on_exit_button_pressed():
	get_tree().quit()

	


func _on_back_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$BackButton.visible = false


func _on_level_1_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_1")


func _on_level_2_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_2")


func _on_level_3_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_3")


func _on_level_4_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_1")


func _on_level_5_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_2")

func _on_level_6_button_pressed():
	lastFocusedButton = get_viewport().gui_get_focus_owner()
	Events.emit_signal("go_to_level", "level_3")
