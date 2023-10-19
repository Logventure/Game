extends Node2D

signal player_position

var pos: Vector2 = Vector2.ZERO
const tilewidth: int = 380
const tileheight: int = 190
@export var speed = 1
var currentLane = 3
var normalMove: String = "normal"
var dashMove: String = "dash"

var log

# Called when the node enters the scene tree for the first time.
func _ready():
	position = pos
	log = get_node("Log")
	Events.connect("player_speed", onUpdatePlayerSpeed)

	
func move(delta):
	pos.x += tilewidth/2 * delta * speed
	pos.y -= tileheight/2 * delta * speed
	
func get_input():
	if Input.is_action_just_pressed("dashLeft") and currentLane == 2:
		currentLane -= 1
		moveLeft(normalMove)
	elif Input.is_action_just_pressed("dashRight") and currentLane == 4:
		currentLane += 1
		moveRight(normalMove)
	elif Input.is_action_just_pressed("dashLeft") and currentLane > 1:
		currentLane -= 2
		moveLeft(dashMove)
	elif Input.is_action_just_pressed("dashRight") and currentLane < 5:
		currentLane += 2
		moveRight(dashMove)
	elif Input.is_action_just_pressed("left") and currentLane > 1:
		moveLeft(normalMove)
		currentLane -= 1
	elif Input.is_action_just_pressed("right") and currentLane < 5:
		moveRight(normalMove)
		currentLane += 1
	#elif Input.is_action_pressed("jump"):
	#	jump(delta) 
	
func moveLeft(aux):
	if aux == "normal":
		log.position.x -= tilewidth/2
		log.position.y -= tileheight/2
	elif aux == "dash":
		log.position.x -= tilewidth
		log.position.y -= tileheight
		
func moveRight(aux):
	if aux == "normal":
		log.position.x += tilewidth/2
		log.position.y += tileheight/2
	elif aux == "dash":
		log.position.x += tilewidth
		log.position.y += tileheight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	move(delta)
	position = Vector2(pos.x, pos.y) 
	Events.emit_signal("player_position",position)


func onUpdatePlayerSpeed(newspeed):
	speed = newspeed