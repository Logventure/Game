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

enum States {IDLE, JUMPING, DROWNING, TAKE_DAMAGE, PAUSED}
var current_state = States.IDLE
var previous_state = States.IDLE



func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	Events.connect("can_jump", can_jump)
	Events.connect("lose_damage", lose_damage)

	Events.connect("on_dialog_start", onPause)
	Events.connect("on_dialog_end", onResume)

	Events.connect("pause_game", onPause)
	Events.connect("resume_game", onResume)



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

func _process(delta):
	var commands = InputHandler.getCommands()
	match current_state:
		States.IDLE:
			handle_position()
			if len(commands) > 0:
				if commands.find("jump") != -1:
					jump()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "jump":
					jump()
					InputHandler.clearLastInput()

		States.JUMPING:
			handle_jump(delta)

		States.DROWNING:
			current_state = States.IDLE

		States.TAKE_DAMAGE:
			pass

		
		States.PAUSED:
			pass

func onPause():
	previous_state = current_state
	current_state = States.PAUSED

func onResume():
	current_state = previous_state
