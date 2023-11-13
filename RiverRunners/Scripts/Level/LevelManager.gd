extends Node2D

@onready var player = $Player
@onready var map = $Map
@onready var dialogue_box = $Camera2D/DialogueBox


signal player_status(position, playerSpeed)

@export var tilesize = 380

var playerPosition = Vector2()
var playerSpeed = 1
var playerTargetSpeed = 1

@export var playerMaxSpeed = 10
@export var playerAcceleration = 0.1

enum States {DIALOG,DIALOG_SETUP,RUNNING,PAUSED,NO_OBSTACLES}

var current_state = States.NO_OBSTACLES

# Called when the node enters the scene tree for the first time.
func _ready():
	#connects to player position signal
	Events.connect("player_position", onUpdatePlayerPosition)
	Events.emit_signal("player_speed",playerSpeed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	print(current_state)

	match current_state:
		States.DIALOG_SETUP:
			dialogue_box.enable()
			map.disableObstacles()
			current_state = States.DIALOG

		States.DIALOG:
			if Input.is_action_just_pressed("text"):
				current_state = States.RUNNING
				map.enableObstacles()
				dialogue_box.disable()

		States.RUNNING:
			managePlayerSpeed()
			if Input.is_action_just_pressed("text"):
				current_state = States.PAUSED

		States.PAUSED:
			player.set_process(false)
			if Input.is_action_just_pressed("text"):
				current_state = States.NO_OBSTACLES
				player.set_process(true)

		States.NO_OBSTACLES:
			managePlayerSpeed()
			map.disableObstacles()
			if Input.is_action_just_pressed("text"):
				current_state = States.DIALOG_SETUP
				

	

func managePlayerSpeed():
	if Input.is_action_just_pressed("spacebar") and playerTargetSpeed + 1 <= playerMaxSpeed:
		playerTargetSpeed+=1
	if Input.is_action_just_pressed("print") and playerTargetSpeed > 1:
		playerTargetSpeed+=-1
	if not playerSpeed == playerTargetSpeed:
		playerSpeed += playerAcceleration * (playerTargetSpeed - playerSpeed)
		Events.emit_signal("player_speed",playerSpeed)
	if abs(playerTargetSpeed - playerSpeed) < 0.01 and not playerTargetSpeed == playerSpeed:
		playerSpeed = playerTargetSpeed
		Events.emit_signal("player_speed",playerSpeed)

func onUpdatePlayerPosition(newposition):
	playerPosition = newposition
