extends Control

class_name FullVersionMenu

var steam_page_uri = "https://store.steampowered.com/app/3835560/River_Runners_Downstream/"

@export var yes_button : TextureButton
@export var no_button : TextureButton

var cooldown_time = 0.1
var current_cooldown_time = cooldown_time + 1

var previous_focus_holder

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visibility(false)
	if yes_button:
		yes_button.connect("pressed",on_yes_pressed)
	if no_button:
		no_button.connect("pressed",on_no_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_cooldown_time += delta
	if visible:
		if InputHandler.hasController() and get_viewport().gui_get_focus_owner() != yes_button and get_viewport().gui_get_focus_owner() != no_button:
			no_button.grab_focus()


func set_visibility(visibility : bool):
	if current_cooldown_time < cooldown_time:
		return
	visible = visibility
	if visibility:
		process_mode = Node.PROCESS_MODE_INHERIT
		if get_viewport().gui_get_focus_owner():
			previous_focus_holder = get_viewport().gui_get_focus_owner()
		no_button.grab_focus()
		current_cooldown_time = 0
	else:
		if previous_focus_holder and previous_focus_holder.has_method("grab_focus"):
			previous_focus_holder.grab_focus()
		#process_mode = Node.PROCESS_MODE_DISABLED
		current_cooldown_time = 0
		
	

func open_steam_page():
	if current_cooldown_time > cooldown_time:
		OS.shell_open(steam_page_uri)
		current_cooldown_time = 0
		set_visibility(false)


func on_yes_pressed():
	open_steam_page()

func on_no_pressed():
	if current_cooldown_time > cooldown_time:
		set_visibility(false)
		current_cooldown_time = 0