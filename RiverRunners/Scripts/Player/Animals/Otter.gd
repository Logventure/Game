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
var throwDestination = 0
var aux_x = 0
var aux_y = 0
var aux1_y = 0
var delay = 0.12
var is_jumping = false
var is_throwing = false

func _ready():
	animal = Animal.new() 
	throwableStone = stone.instantiate()
	add_child(throwableStone)
	pos_original = position
	pos = position.y
	Events.connect("input_jump", jump)
	Events.connect("input_throw", throw)

func jump():
	if not is_jumping:
		is_jumping = true
		jumpTime = -1*delay

func handle_jump(delta): 
	jumpTime += delta
	if is_jumping && position.y <= pos && jumpTime >= 0:
		position.y = pos - (jumpSpeed + jumpGravity * jumpTime * -1) * jumpTime 
	elif jumpTime >= 0:
		is_jumping = false
		position.y = pos
	
func throw():
	if not is_throwing:
		is_throwing = true
		throwTime = 0
		throwDestination = Vector2(position.x + (tilewidth * 15), position.y - (tileheight * 15))

func handle_throw(delta):
	throwTime += delta
	if is_throwing && throwableStone.position.x <= throwDestination.x && throwableStone.position.y >= throwDestination.y && throwTime >= 0: #criar variaveis auxiliares para x e para y onde depois guardo no final na position da stone
		aux_x = pos_original.x + tilewidth/2 * throwTime * throwSpeedX
		aux_y = pos_original.y - tileheight/2 * throwTime * throwSpeedX
		aux1_y = aux_y - (throwSpeedY + throwGravity * throwTime * -1) * throwTime
		throwableStone.position = Vector2(aux_x, aux1_y)
	elif throwTime >= 0:
		is_throwing = false
		#throwableStone.queue_free() mudar de sitio

func _process(delta):
	handle_jump(delta)
	handle_throw(delta)
