extends Control

@onready var animation = $AnimationPlayer
@onready var timer = $Timer
@onready var label1 = $Label
@onready var label2 = $Label2
@onready var label3 = $Label3
@onready var label4 = $Label4
@onready var label5 = $Label5
@onready var label6 = $Label6
@onready var label7 = $Label7
@onready var label8 = $Label8
@onready var label9 = $Label9
@onready var label10 = $Label10
@onready var label11 = $Label11
@onready var label12 = $Label12
@onready var label13 = $Label13
@onready var label14 = $Label14
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
		label1.position.y -= 2.5 * delta * 60
		label2.position.y -= 2.5 * delta * 60
		label3.position.y -= 2.5 * delta * 60
		label4.position.y -= 2.5 * delta * 60
		label5.position.y -= 2.5 * delta * 60
		label6.position.y -= 2.5 * delta * 60
		label7.position.y -= 2.5 * delta * 60
		label8.position.y -= 2.5 * delta * 60
		label9.position.y -= 2.5 * delta * 60
		label10.position.y -= 2.5 * delta * 60
		label12.position.y -= 2.5 * delta * 60
		label13.position.y -= 2.5 * delta * 60
		#label14.position.y -= 2.5 * delta * 60

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
	label1.position.y = 1081
	#label12.position.y = 1370
	#label13.position.y = 1700
	#label14.position.y = 1250
	label2.position.y = 1350
	label3.position.y = 1430
	label4.position.y = 1430
	label5.position.y = 2320
	label6.position.y = 2400
	label7.position.y = 2400
	label8.position.y = 3170
	label9.position.y = 3260
	label10.position.y = 3260
	label11.text = ""
	label12.position.y = 4950
	label13.position.y = 5400
	Events.emit_signal("go_from_credits_to_main_menu")

func skipKey():
	var input_type = InputHandler.lastInputType()
	var confirm_actions = InputMap.action_get_events("confirm")
	var keyString
	
	if input_type == "controller":
		keyString = "X"
		label11.text = str("Hold ", keyString, " to skip.")
	elif input_type == "kbm":
		var keyCode = confirm_actions[0].physical_keycode
		keyString = OS.get_keycode_string(keyCode)
		label11.text = str("Hold ", keyString, " to skip.")
