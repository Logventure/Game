extends Node2D

signal player_position
var pos: Vector2 = Vector2.ZERO
const tilewidth: int = 380
const tileheight: int = 190
@export var speed = 1
@export var base_speed = 1000 #speed used on a normal move
@export var dash_speed = 2000 #speed used on a dash
@export var correct_speed = 3000 #speed used when correcting the log's position after hitting a obstacle
var move_speed = base_speed
var currentLane = 3
var laneStatus = {1 : true, 2 : true, 3 : true, 4 : true, 5 : true}
var normalMove: String = "normal"
var dashMove: String = "dash"
var destination = Vector2.ZERO
var distance = Vector2.ZERO
var deltaTime = 0
@export var multiplier = 0.05
var aux = 0
var is_done = true
var log
var is_on_air = 0

var lanePositions = {}

enum States {IDLE, MOVING, DIALOG}

var current_state = States.IDLE


#adicionar variavel que indique quantos animais estao no tronco a partir do level manager

# Called when the node enters the scene tree for the first time.
func _ready():
	position = pos
	log = get_node("Log")
	Events.connect("player_speed", onUpdatePlayerSpeed)

	Events.connect("on_dialog_start", onDialogStart)
	Events.connect("on_dialog_end", onDialogEnd)

	Events.connect("is_lane_free", onUpdateLaneStatus)
	Events.connect("log_collided", moveToFreeLane)

	Events.connect("is_on_air", isOnAir)

func move(delta):
	pos.x += tilewidth/2 * delta * speed
	pos.y -= tileheight/2 * delta * speed
	
	
func moveLeft():
	if current_state == States.IDLE:
		if currentLane > 1:
			currentLane -= 1
			destination = lanePosition(currentLane)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			move_speed = base_speed
			deltaTime = move_speed + distance * multiplier
			current_state = States.MOVING

func moveRight():
	if current_state == States.IDLE:
		if currentLane < 5:
			currentLane += 1
			destination = lanePosition(currentLane)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			move_speed = base_speed
			deltaTime = move_speed + distance * multiplier
			current_state = States.MOVING
		
func dashLeft():
	if current_state == States.IDLE:
		if currentLane > 2:
			currentLane -= 2
			destination = lanePosition(currentLane)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			move_speed = dash_speed
			deltaTime = move_speed + distance * multiplier
		elif currentLane > 1:
			currentLane -= 1
			destination = lanePosition(currentLane)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			move_speed = dash_speed
			deltaTime = move_speed + distance * multiplier
		current_state = States.MOVING

func dashRight():
	if current_state == States.IDLE:
		if currentLane < 4:
			currentLane += 2
			destination = lanePosition(currentLane)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			move_speed = dash_speed
			deltaTime = move_speed + distance * multiplier
		elif currentLane < 5:
			currentLane += 1
			destination = lanePosition(currentLane)
			aux = destination - log.position
			distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
			move_speed = dash_speed
			deltaTime = move_speed + distance * multiplier
		current_state = States.MOVING

func moveTo(lane: int):
	if lane > 0 and lane < 6:
		currentLane = lane
		destination = lanePosition(currentLane)
		aux = destination - log.position
		distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
		deltaTime = move_speed + distance * multiplier
		current_state = States.MOVING

func moveToFreeLane():
	var direction = 1
	move_speed = correct_speed
	if currentLane < 3:
		direction = 1
	elif currentLane > 3:
		direction = -1
	else:
		direction = randf() - 0.5
		direction = direction / abs(direction)
	for i in range(1,4):
		if laneStatus.get(int(currentLane + i * direction),false):
			moveTo(currentLane + i * direction)
			return
		if laneStatus.get(int(currentLane - i * direction),false):
			moveTo(currentLane - i * direction)
			return
		
func lanePosition(lane: int):
	var offset = lane - 3
	return Vector2(tilewidth/2 * offset, tileheight/2 * offset)

func updateDeltaTime():
	deltaTime = move_speed + log.position.distance_to(destination) * multiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var commands = InputHandler.getCommands()
	match current_state:
		States.IDLE:
			if len(commands) > 0:
				if commands.find("move_left") != -1:
					moveLeft()
				elif commands.find("move_right") != -1:
					moveRight()
				elif commands.find("dash_left") != -1:
					dashLeft()
				elif commands.find("dash_right") != -1:
					dashRight()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "move_left":
					moveLeft()
					InputHandler.clearLastInput()
				if last_input == "move_right":
					moveRight()
					InputHandler.clearLastInput()
				if last_input == "dash_left":
					dashLeft()
					InputHandler.clearLastInput()
				if last_input == "dash_right":
					dashRight()
					InputHandler.clearLastInput()
			
		States.MOVING:
			if (log.position == destination):
				current_state = States.IDLE

		States.DIALOG:


			pass

	move(delta)
	updateDeltaTime()
	log.position = log.position.move_toward(destination, deltaTime * delta)
	if (log.position == destination):
		updateZindex()
	position = Vector2(pos.x, pos.y) 
	Events.emit_signal("player_position", position)

func onUpdatePlayerSpeed(newspeed):
	speed = newspeed

func updateZindex():
	z_index = (currentLane - 3) * 5 + 2

func onUpdateLaneStatus(lane_offset,status):
	var lane_id = currentLane + lane_offset
	if lane_id in laneStatus.keys():
		laneStatus[lane_id] = status

func onDialogStart():
	current_state = States.DIALOG
	print("on dialog start")

func onDialogEnd():
	current_state = States.MOVING
	print("on dialog end")

func isOnAir(on_air : bool):
	if on_air:
		is_on_air += 1
	else:
		is_on_air -= 1
	if is_on_air == 0:
		Events.emit_signal("can_jump", true)
	elif is_on_air == 3:
		Events.emit_signal("can_jump", false)
