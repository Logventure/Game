extends Camera2D

var playerPosition = Vector2()
var playerSpeed = 0.0

@export var minDistance = 5
@export var multiplier = 1

@export var baseZoom = 0.5
@export var minZoom = 0.3
@export var zoomMultiplier = 0.01


# Called when the node enters the scene tree for the first time.
func _ready():
	#connects to player position signal (from LevelManager)
	var level = get_node("../")
	level.player_status.connect(onUpdatePlayerStatus)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCameraPosition()
	updateCameraZoom()


func onUpdatePlayerStatus(position: Vector2,speed):
	playerPosition = position
	playerSpeed = speed

func updateCameraPosition():
	position = Vector2(playerPosition.x + (minDistance + playerSpeed*multiplier) * 2, playerPosition.y - (minDistance + playerSpeed*multiplier))

func updateCameraZoom():
	var zoom_value = baseZoom - playerSpeed * zoomMultiplier
	if zoom_value >= minZoom and zoom_value > 0:
		zoom = Vector2(zoom_value,zoom_value)
