extends Node2D

signal player_status(position, playerSpeed)

@export var tilesize = 380

var playerPosition = Vector2()
var playerSpeed = 1
var playerTargetSpeed = 1

@export var playerMaxSpeed = 10
@export var playerAcceleration = 0.1


var player_hp = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	#connects to player position signal
	Events.connect("player_position", onUpdatePlayerPosition)
	Events.connect("damage_taken", onDamageTaken)

	Events.emit_signal("player_speed",playerSpeed)

	get_node("Camera2D/Label").text = str(player_hp)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("spacebar") and playerTargetSpeed + 1 <= playerMaxSpeed:
		playerTargetSpeed+=1
	if Input.is_action_just_pressed("print") and playerTargetSpeed > 1:
		playerTargetSpeed+=-1
	managePlayerSpeed()


	

func managePlayerSpeed():
	if not playerSpeed == playerTargetSpeed:
		playerSpeed += playerAcceleration * (playerTargetSpeed - playerSpeed)
		Events.emit_signal("player_speed",playerSpeed)
	if abs(playerTargetSpeed - playerSpeed) < 0.01 and not playerTargetSpeed == playerSpeed:
		playerSpeed = playerTargetSpeed
		Events.emit_signal("player_speed",playerSpeed)

func onUpdatePlayerPosition(newposition):
	playerPosition = newposition

func onDamageTaken(damage):
	player_hp += -1 * damage
	get_node("Camera2D/Label").text = str(player_hp)
