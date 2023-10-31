extends Sprite2D

var animal
var stone = load("res://GameComponents/Player/stone.tscn")
var throwableStone
const tilewidth: int = 380
const tileheight: int = 190
var pos = Vector2.ZERO
var pos_original = Vector2.ZERO
var jumpGravity = 400
var jumpTime = 0
var jumpSpeed = 500
var throwGravity = 400
var throwSpeedX = 2.5
var throwSpeedY = 500
var throwTime = 0
var throwoffset = 90
var throwDestination = 0
var aux_x = 0
var aux_y = 0
var aux1_y = 0
var delay = 0.12
var is_jumping = false
var is_throwing = false
var logNode
var basePosition = position

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	pos = position.y
	Events.connect("input_jump", jump)
	Events.connect("input_throw", throw)

func jump():
	if not is_jumping:
		is_jumping = true
		jumpTime = -1*delay
		pos = logNode.position.y + basePosition.y


func handle_jump(delta): 
	jumpTime += delta
	if is_jumping && position.y <= pos && jumpTime >= 0:
		position.y = pos - (jumpSpeed + jumpGravity * jumpTime * -1) * jumpTime 
	elif jumpTime >= 0:
		if(is_jumping):	#acabou o salto
			position.y = pos
			is_jumping = false
			if not logNode.position.x + basePosition.x == position.x:
				print("Rip otter")
	
func handle_position():
	if not is_jumping:
		position = logNode.position + basePosition

	
func throw():
	Events.emit_signal("otter_position",position)

func _process(delta):
	handle_position()
	handle_jump(delta)
