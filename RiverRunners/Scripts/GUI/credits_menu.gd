extends Control

@onready var animation = $AnimationPlayer
@onready var timer = $Timer
var onCredits = false
var skipTime = 0

var holdtime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("go_from_main_menu_to_credits", credits)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if onCredits:
		skipTime += delta
		if skipTime > 5:
			skipKey()
			holdToSkip(delta)
		else:
			$loader_circle.set_frame_and_progress(0, 0)
		#if Input.is_action_just_pressed("confirm") and skipTime > 5:
			#on_timer_timeout()
		$Label.position.y -= 2.5 * delta * 60
		$Label2.position.y -= 2.5 * delta * 60
		$Label3.position.y -= 2.5 * delta * 60
		$Label4.position.y -= 2.5 * delta * 60
		$Label5.position.y -= 2.5 * delta * 60
		$Label6.position.y -= 2.5 * delta * 60
		$Label7.position.y -= 2.5 * delta * 60
		$Label8.position.y -= 2.5 * delta * 60
		$Label9.position.y -= 2.5 * delta * 60
		$Label10.position.y -= 2.5 * delta * 60

func credits():
	timer.start(34)
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
	$Label.position.y = 1081
	$Label2.position.y = 1350
	$Label3.position.y = 1430
	$Label4.position.y = 1430
	$Label5.position.y = 2320
	$Label6.position.y = 2400
	$Label7.position.y = 2400
	$Label8.position.y = 3170
	$Label9.position.y = 3260
	$Label10.position.y = 3260
	$Label11.text = ""
	Events.emit_signal("go_from_credits_to_main_menu")

func skipKey():
	var input_type = InputHandler.lastInputType()
	var confirm_actions = InputMap.action_get_events("confirm")
	var keyString
	print("type: ", input_type)
	if input_type == "controller":
		keyString = "X"
		$Label11.text = str("Hold ", keyString, " to skip.")
	elif input_type == "kbm":
		var keyCode = confirm_actions[0].physical_keycode
		keyString = OS.get_keycode_string(keyCode)
		$Label11.text = str("Hold ", keyString, " to skip.")
