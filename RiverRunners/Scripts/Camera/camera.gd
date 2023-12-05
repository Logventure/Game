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
	#connects to player position signal	
	Events.connect("player_position", onUpdatePlayerPosition)
	Events.connect("player_speed", onUpdatePlayerSpeed)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCameraPosition()
	updateCameraZoom()
	Events.emit_signal("camera_status",position,zoom)

func onUpdatePlayerPosition(position):
	playerPosition = position

func onUpdatePlayerSpeed(speed):
	playerSpeed = speed

func updateCameraPosition():
	position = Vector2(playerPosition.x + (minDistance + playerSpeed*multiplier) * 2, playerPosition.y - (minDistance + playerSpeed*multiplier))


func updateCameraZoom():
	var zoom_value = baseZoom - playerSpeed * zoomMultiplier
	var scale_value = baseZoom/zoom_value
	if zoom_value >= minZoom and zoom_value > 0 and zoom_value != zoom.x:
		zoom = Vector2(zoom_value,zoom_value)
		scale = Vector2(scale_value,scale_value)
