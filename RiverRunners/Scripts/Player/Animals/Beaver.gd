extends Sprite2D

var animal
#var destination = Vector2.ZERO
#var aux1 = Vector2.ZERO #variavel auxiliar
#var aux2 = Vector2.ZERO #variavel auxiliar
var pos = Vector2.ZERO
var gravity = 9
var time = 0
var speed = 60
var delay = 0
var is_jumping = false
#var array = {}
#var array1 = {}

func _ready():
	animal = Animal.new() 
	pos = position.y
	Events.connect("input_jump", jump)

func jump():
	if !is_jumping:
		is_jumping = true
		time = -1*delay

		"""array = animal.jump(position, delay)
		destination = array[0]
		deltaTime = array[1]
		aux1 = array[0]"""

func handle_jump(delta): 
	print(pos , "      " , position.y)
	time += delta
	print("is_jumping: ",is_jumping)
	print("position: ",position.y <= pos)
	print("time: ",time >= 0)
	if is_jumping && position.y >= pos && time >= 0:
		position.y = pos + (speed + gravity * time * -1) * time 
		print("entrou")
	else:
		is_jumping = false
	
	"""array1 = animal.fall(position, delay)
	destination = array1[0]
	deltaTime = array1[1]
	aux2 = array1[0]"""

func _process(delta):
	print(is_jumping)
	handle_jump(delta)
