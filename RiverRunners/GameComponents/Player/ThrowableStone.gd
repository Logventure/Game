extends Node2D

var stone = load("res://GameComponents/Player/stone.tscn")
var throwableStone = null
const tilewidth: int = 380
const tileheight: int = 190
var pos_original = Vector2.ZERO
var is_throwing = false
var throwGravity = 400
var throwSpeedX = 2.5
var throwSpeedY = 500
var throwTime = 0
var throwoffset = 0
var throwDestination = 0
var aux_x = 0
var aux_y = 0
var aux1_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("otter_position", throw)

func throw(otter_position):
	if not is_throwing and throwableStone == null:
		throwableStone = stone.instantiate()
		add_child(throwableStone)
		pos_original = otter_position
		pos_original.y += throwoffset
		is_throwing = true
		throwTime = 0
		throwDestination = Vector2(position.x + (tilewidth * 5), position.y - (tileheight * 5))

func handle_throw(delta):
	throwTime += delta
	if is_throwing && throwableStone.position.x <= throwDestination.x && throwableStone.position.y >= throwDestination.y && throwTime >= 0: #criar variaveis auxiliares para x e para y onde depois guardo no final na position da stone
		aux_x = pos_original.x + tilewidth/2 * throwTime * throwSpeedX
		aux_y = pos_original.y - tileheight/2 * throwTime * throwSpeedX
		aux1_y = aux_y - (throwSpeedY + throwGravity * throwTime * -1) * throwTime
		throwableStone.position = Vector2(aux_x, aux1_y)
	elif throwTime >= 0:
		is_throwing = false
		if not throwableStone == null: 
			throwableStone.queue_free()
			throwableStone = null

func _process(delta):
	handle_throw(delta)
