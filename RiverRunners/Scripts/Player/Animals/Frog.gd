extends Sprite2D

var animal
var pos = Vector2.ZERO
var gravity = 400
var time = 0
var speed = 500
var delay = 0.24
var is_jumping = false
var logNode
var basePosition = position
var canJump = true
var loseDamage = true

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	Events.connect("input_jump", jump)
	Events.connect("can_jump", can_jump)
	Events.connect("lose_damage", lose_damage)


func jump():
	if not is_jumping && canJump:
		is_jumping = true
		time = -1*delay
		pos = logNode.position.y + basePosition.y
		Events.emit_signal("is_on_air", true)
		loseDamage = true


func handle_jump(delta): 
	time += delta
	if is_jumping && position.y <= pos && time >= 0:
		position.y = pos - (speed + gravity * time * -1) * time 
	elif time >= 0:
		if(is_jumping):	#acabou o salto
			position.y = pos
			is_jumping = false
			Events.emit_signal("is_on_air", false)
			if not logNode.position.x + basePosition.x == position.x && loseDamage:
				print("Rip froggo")
				Events.emit_signal("lose_damage", false)

				Events.emit_signal("damage_taken", 1)

func can_jump(value: bool):
	canJump = value

func lose_damage(value: bool):
	loseDamage = value
	
func handle_position():
	if not is_jumping:
		position = logNode.position + basePosition

func _process(delta):
	handle_position()
	handle_jump(delta)
	