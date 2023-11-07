extends Node2D

signal player_position
var pos: Vector2 = Vector2.ZERO
const tilewidth: int = 380
const tileheight: int = 190
@export var speed = 1
var currentLane = 3
var normalMove: String = "normal"
var dashMove: String = "dash"
var destination = Vector2.ZERO
var distance = Vector2.ZERO
var deltaTime = 0
var multiplier = 0.05
var aux = 0
var is_done = true
var log
var is_on_air = 0

#adicionar variavel que indique quantos animais estao no tronco a partir do level manager

# Called when the node enters the scene tree for the first time.
func _ready():
	position = pos
	log = get_node("Log")
	Events.connect("player_speed", onUpdatePlayerSpeed)

	Events.connect("input_move_left", moveLeft)
	Events.connect("input_move_right", moveRight)
	Events.connect("input_dash_left", dashLeft)
	Events.connect("input_dash_right", dashRight)

	Events.connect("is_on_air", isOnAir)

func move(delta):
	pos.x += tilewidth/2 * delta * speed
	pos.y -= tileheight/2 * delta * speed
	
#func get_input():
#	if Input.is_action_just_pressed("dashLeft") and currentLane == 2:
#		currentLane -= 1
#		moveLeft(normalMove)
#	elif Input.is_action_just_pressed("dashRight") and currentLane == 4:
#		currentLane += 1
#		moveRight(normalMove)
#	elif Input.is_action_just_pressed("dashLeft") and currentLane > 1:
#		currentLane -= 2
#		moveLeft(dashMove)
#	elif Input.is_action_just_pressed("dashRight") and currentLane < 5:
#		currentLane += 2
#		moveRight(dashMove)
#	elif Input.is_action_just_pressed("left") and currentLane > 1:
#		moveLeft(normalMove)
#		currentLane -= 1
#	elif Input.is_action_just_pressed("right") and currentLane < 5:
#		moveRight(normalMove)
#		currentLane += 1
	#elif Input.is_action_pressed("jump"):
	#	jump(delta) 
	
func moveLeft():
	if is_done:
		if currentLane > 1:
			#log.position.x -= tilewidth/2
			#log.position.y -= tileheight/2
			currentLane -= 1
			destination = Vector2(log.position.x - tilewidth/2, log.position.y - tileheight/2)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			deltaTime = speed + distance * multiplier
			is_done = false

func moveRight():
	if is_done:
		if currentLane < 5:
			#log.position.x += tilewidth/2
			#log.position.y += tileheight/2
			currentLane += 1
			destination = Vector2(log.position.x + tilewidth/2, log.position.y + tileheight/2)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			deltaTime = speed + distance * multiplier
			is_done = false
		
func dashLeft():
	if is_done:
		if currentLane > 2:
			#log.position.x -= tilewidth
			#log.position.y -= tileheight
			currentLane -= 2
			destination = Vector2(log.position.x - tilewidth, log.position.y - tileheight)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			deltaTime = speed + distance * multiplier
		elif currentLane > 1:
			#log.position.x -= tilewidth/2
			#log.position.y -= tileheight/2
			currentLane -= 1
			destination = Vector2(log.position.x - tilewidth/2, log.position.y - tileheight/2)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			deltaTime = speed + distance * multiplier
		is_done = false

func dashRight():
	if is_done:
		if currentLane < 4:
			#log.position.x += tilewidth
			#log.position.y += tileheight
			currentLane += 2
			destination = Vector2(log.position.x + tilewidth, log.position.y + tileheight)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			deltaTime = speed + distance * multiplier
		elif currentLane < 5:
			#log.position.x += tilewidth/2
			#log.position.y += tileheight/2
			currentLane += 1
			destination = Vector2(log.position.x + tilewidth/2, log.position.y + tileheight/2)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			deltaTime = speed + distance * multiplier
		is_done = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_input()
	move(delta)
	log.position = log.position.move_toward(destination, deltaTime)
	if (log.position == destination):
		is_done = true
	position = Vector2(pos.x, pos.y) 
	Events.emit_signal("player_position", position)
	print(is_on_air)

func onUpdatePlayerSpeed(newspeed):
	speed = newspeed

func isOnAir(on_air : bool):
	if on_air:
		is_on_air += 1
	else:
		is_on_air -= 1
	if is_on_air == 0:
		Events.emit_signal("can_jump", true)
	elif is_on_air == 3:
		Events.emit_signal("can_jump", false)