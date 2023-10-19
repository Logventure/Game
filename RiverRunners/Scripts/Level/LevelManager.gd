extends Node2D

signal player_status(position, playerSpeed)

@export var tilesize = 380

var playerPosition = Vector2()
var playerSpeed = 1
var playerTargetSpeed = 1

@export var playerMaxSpeed = 10
@export var playerAcceleration = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	#connects to player position signal
	Events.connect("player_position", onUpdatePlayerPosition)
	
	Events.emit_signal("player_speed",playerSpeed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("spacebar") and playerTargetSpeed + 1 <= playerMaxSpeed:
		playerTargetSpeed+=1
	managePlayerSpeed()

func managePlayerSpeed():
	if playerSpeed < playerTargetSpeed:
		playerSpeed += playerAcceleration * (playerTargetSpeed - playerSpeed)
		Events.emit_signal("player_speed",playerSpeed)
	if abs(playerTargetSpeed - playerSpeed) < 0.01 and not playerTargetSpeed == playerSpeed:
		playerSpeed = playerTargetSpeed
		Events.emit_signal("player_speed",playerSpeed)

func onUpdatePlayerPosition(newposition):
	playerPosition = newposition

