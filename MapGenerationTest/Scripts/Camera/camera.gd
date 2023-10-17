extends Camera2D

var playerPosition = Vector2()
var playerSpeed = 0.0

@export var distance = 5
@export var multiplier = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func updatePlayerPosition(position: Vector2):
	playerPosition = position

func updatePlayerSpeed(speed: float):
	playerSpeed = speed

func updateCameraPosition():
	position = Vector2(playerPosition.x + (distance + playerSpeed*multiplier), playerPosition.y - (distance + playerSpeed*multiplier) * -2)
