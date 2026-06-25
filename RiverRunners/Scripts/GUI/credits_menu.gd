extends Control

@onready var animation = $AnimationPlayer
@onready var timer = $Timer
@onready var credits_text = $TextParent
@onready var skiplabel = $Skip

var onCredits = false
var skipTime = 0
var holdtime = 0

var original_position : Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("go_from_main_menu_to_credits", credits)
	Events.input_type_changed.connect(on_input_type_changed)
	original_position = credits_text.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if onCredits:
		skipTime += delta
		if skipTime > 5:
			skipKey()
			holdToSkip(delta)
		else:
			$loader_circle.set_frame_and_progress(0, 0)
			skiplabel.visible = false
		credits_text.position.y -= 2.5 * delta * 60

func credits():
	timer.start(38) #normal version -> 38  no credits -> 13
	skipTime = 0
	animation.play("credits_loop")
	onCredits = true

func holdToSkip(delta):
	if Input.is_action_pressed("confirm"):
		holdtime += delta
		if holdtime > 0.1:
			if not $loader_circle.is_playing():
				$loader_circle.play("load")
		if holdtime > 1.0:
			on_timer_timeout()
		
	else:
		holdtime = 0
		$loader_circle.set_frame_and_progress(0, 0)

func on_timer_timeout():
	onCredits = false
	credits_text.position = original_position
	Events.emit_signal("go_from_credits_to_main_menu")

func skipKey():
	skiplabel.visible = true
	var input_controller = InputHandler.lastInputType() == "controller"
	var confirm_actions = InputMap.action_get_events("confirm")
	var keyString
	
	if input_controller:
		keyString = tr("KEY_CROSS")
		skiplabel.text = tr("CREDITSSKIP").format({key = keyString})
	else:
		var keyCode = confirm_actions[0].physical_keycode
		keyString = tr(OS.get_keycode_string(keyCode))
		skiplabel.text = tr("CREDITSSKIP").format({key = keyString})

func on_input_type_changed():
	if skiplabel.visible:
		skipKey()