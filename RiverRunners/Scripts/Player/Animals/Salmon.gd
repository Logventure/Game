extends Sprite2D

var animal
var logNode
var basePosition = position

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	
func handle_position():
	position = logNode.position + basePosition

func _process(delta):
	var char_available = get_node("../").isCharacterAvailable("salmon")
	if visible != char_available:
		visible = char_available

	handle_position()
	