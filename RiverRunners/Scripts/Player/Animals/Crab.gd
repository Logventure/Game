extends Sprite2D

var animal
var pos = Vector2.ZERO
var gravity = 400
var time = 0
var speed = 500
var delay = 0
var is_jumping = false
var logNode
var basePosition = position

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	Events.connect("input_jump", jump)

func jump():
	if not is_jumping:
		is_jumping = true
		time = -1*delay
		pos = logNode.position.y + basePosition.y


func handle_jump(delta): 
	time += delta
	if is_jumping && position.y <= pos && time >= 0:
		position.y = pos - (speed + gravity * time * -1) * time 
	elif time >= 0:
		if(is_jumping):	#acabou o salto
			position.y = pos
			is_jumping = false
			if not logNode.position.x + basePosition.x == position.x:
				print("Rip crabby")
				#Events.emit_signal("damage_taken", currentHealth)

func handle_position():
	if not is_jumping:
		position = logNode.position + basePosition

func _process(delta):
	handle_position()
	handle_jump(delta)
	