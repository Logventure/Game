extends Sprite2D

var animal
var pos = Vector2.ZERO
var gravity = 400
var time = 0
var speed = 500
var delay = 0.24
var is_jumping = false

func _ready():
	animal = Animal.new() 
	pos = position.y
	Events.connect("input_jump", jump)

func jump():
	if not is_jumping:
		is_jumping = true
		time = -1*delay


func handle_jump(delta): 
	time += delta
	if is_jumping && position.y <= pos && time >= 0:
		position.y = pos - (speed + gravity * time * -1) * time 
	elif time >= 0:
		if(is_jumping):	#acabou o salto
			pass
		is_jumping = false
		position.y = pos
	

func _process(delta):
	handle_jump(delta)
