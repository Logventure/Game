extends AnimatedSprite2D

var animal
var pos = Vector2.ZERO
var gravity = 400
var time = 0
var speed = 500
var delay = 0.36
var is_jumping = false
var logNode
var basePosition = position

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	
func handle_position():
	if not is_jumping:
		position = logNode.position + basePosition

func _process(delta):
	var char_available = get_node("../").isCharacterAvailable("beaver")
	if visible != char_available:
		visible = char_available

	handle_position()
	play("idle")
	
