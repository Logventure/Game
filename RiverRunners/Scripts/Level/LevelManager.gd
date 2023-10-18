extends Node2D

signal player_status #includes position and speed

@export var tilesize = 380

var playerPosition = Vector2()
var playerSpeed = 1
var playerTargetSpeed = 1

@export var playerMaxSpeed = 10

@export var playerAcceleration = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerPosition = moveLog(delta)
	
	player_status.emit(playerPosition,playerSpeed)

	if Input.is_action_just_pressed("spacebar") and playerTargetSpeed + 1 <= playerMaxSpeed:
		playerTargetSpeed+=1

	if playerSpeed < playerTargetSpeed:
		playerSpeed += playerAcceleration * (playerTargetSpeed - playerSpeed)
	if abs(playerTargetSpeed - playerSpeed) < 0.01:
		playerSpeed = playerTargetSpeed



#temporary
func moveLog(delta):
	var log = get_node("Sprite2D")
	log.position = Vector2(log.position.x + playerSpeed * delta * tilesize / 2, log.position.y + playerSpeed * delta * tilesize / -4)
	return log.position
