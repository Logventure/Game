extends Camera2D

var playerPosition = Vector2()
var playerSpeed = 0.0

@export var minDistance = 5
@export var multiplier = 1

@export var baseZoom = 0.8
@export var minZoom = 0.3
@export var zoomMultiplier = 0.01

var shakeTime = 1.1

var shakeSpeed = 1000
var shakeAccel = 100

var noisePosition = Vector2.ZERO
var noiseTargetPosition = Vector2.ZERO

var shakeStrength = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	#connects to player position signal	
	Events.connect("player_position", onUpdatePlayerPosition)
	Events.connect("player_speed", onUpdatePlayerSpeed)

	Events.connect("damage_taken", onDamageTaken)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCameraPosition(delta)
	updateCameraZoom()
	Events.emit_signal("camera_status",position,zoom)

func onUpdatePlayerPosition(position):
	playerPosition = position

func onUpdatePlayerSpeed(speed):
	playerSpeed = speed

func updateCameraPosition(delta):
	shakeTime += delta
	var noise = getNoiseOffset(delta)
	var maxShake = 0.5 - shakeTime 
	if maxShake < 0:
		maxShake = 0
	noise = Vector2(noise.x * maxShake, noise.y * maxShake)
	$ColorRect.modulate.a = maxShake / 6

	position = Vector2(playerPosition.x + (minDistance + playerSpeed*multiplier) * 2 + noise.x, playerPosition.y - (minDistance + playerSpeed*multiplier) + noise.y)


func updateCameraZoom():
	var zoom_value = baseZoom - playerSpeed * zoomMultiplier
	var scale_value = baseZoom/zoom_value
	if zoom_value >= minZoom and zoom_value > 0 and zoom_value != zoom.x:
		zoom = Vector2(zoom_value,zoom_value)
		scale = Vector2(scale_value,scale_value)

func onDamageTaken(dmg):
	shakeTime = 0

func applyShake(delta):
	shakeTime += delta
	if shakeTime < 1:
		var noise = getNoiseOffset(delta)
		position = Vector2(position.x + noise.x, position.y + noise.y)

func getNoiseOffset(delta):
	if noiseTargetPosition == noisePosition:
		noiseTargetPosition = Vector2(randi_range(-1*shakeStrength, shakeStrength), randi_range(-1*shakeStrength, shakeStrength))
	
	var speed = delta * (shakeSpeed + noisePosition.distance_to(noiseTargetPosition) * shakeAccel)
	noisePosition = noisePosition.move_toward(noiseTargetPosition, speed)

	return noisePosition