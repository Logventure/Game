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
	handle_position()
	