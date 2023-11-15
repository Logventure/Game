extends Sprite2D

var animal
var stone = load("res://GameComponents/Player/stone.tscn")
var throwableStone
const tilewidth: int = 380
const tileheight: int = 190
var pos = Vector2.ZERO
var pos_original = Vector2.ZERO
var gravity = 400
var time = 0
var speed = 500
var delay = 0.12
var is_jumping = false
var logNode
var basePosition = position
var canJump = true
var loseDamage = true

enum States {IDLE, JUMPING, DROWNING, TAKE_DAMAGE, DIALOG}
var current_state = States.IDLE

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	pos = position.y
	Events.connect("can_jump", can_jump)
	Events.connect("lose_damage", lose_damage)

	Events.connect("on_dialog_start", onDialogStart)
	Events.connect("on_dialog_end", onDialogEnd)

func jump():
	if canJump:
		current_state = States.JUMPING
		time = -1*delay
		pos = logNode.position.y + basePosition.y
		Events.emit_signal("is_on_air", true)
		loseDamage = true

func handle_jump(delta): 
	time += delta
	if position.y <= pos && time >= 0:
		position.y = pos - (speed + gravity * time * -1) * time 
	elif time >= 0:
		position.y = pos
		current_state = States.IDLE
		Events.emit_signal("is_on_air", false)
		if not logNode.position.x + basePosition.x == position.x && loseDamage:
			print("Rip crabby")
			Events.emit_signal("lose_damage", false)
			Events.emit_signal("damage_taken", 1)
			current_state = States.DROWNING
		

func can_jump(value: bool):
	canJump = value
	
func lose_damage(value: bool):
	loseDamage = value

func handle_position():
	position = logNode.position + basePosition
	
func throw():
	Events.emit_signal("otter_position",position)


func _process(delta):
	var commands = InputHandler.getCommands()
	match current_state:
		States.IDLE:
			handle_position()
			if len(commands) > 0:
				if commands.find("jump") != -1:
					jump()
				if commands.find("throw") != -1:
					throw()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "jump":
					jump()
					InputHandler.clearLastInput()
				elif last_input == "throw":
					throw()
					InputHandler.clearLastInput()

		States.JUMPING:
			handle_jump(delta)
			if len(commands) > 0:
				if commands.find("throw") != -1:
					throw()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "throw":
					throw()
					InputHandler.clearLastInput()

		States.DROWNING:
			current_state = States.IDLE

		States.TAKE_DAMAGE:
			pass

		States.DIALOG:
			pass

func onDialogStart():
	current_state = States.DIALOG
	print("on dialog start")

func onDialogEnd():
	current_state = States.IDLE
	print("on dialog end")