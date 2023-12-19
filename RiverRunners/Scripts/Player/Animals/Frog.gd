extends AnimatedSprite2D

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

@onready var collider = get_node("FrogCollider")
var collider_pos

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	Events.connect("can_jump", can_jump)
	Events.connect("lose_damage", lose_damage)

	Events.connect("on_dialog_start", onPause)
	Events.connect("on_dialog_end", onResume)

	Events.connect("pause_game", onPause)
	Events.connect("resume_game", onResume)

	collider.connect("area_entered",onTreeDetected)
	collider_pos = collider.position

func jump():
	if canJump:
		current_state = States.JUMPING
		time = -1*delay
		pos = logNode.position.y + basePosition.y
		Events.emit_signal("is_on_air", true)
		loseDamage = true

func handle_jump(delta): 
	if time <= 0 and time + delta >= 0:
		Utils.playSoundFile(self,"res://Assets/Audio/SFX/jump5.wav","SFX",-12)
	time += delta
	if position.y <= pos && time >= 0:
		position.y = pos - (speed + gravity * time * -1) * time
		z_index = int((speed + gravity * time * -1) * time / 30) * 2 + 2
		collider.position.y = collider_pos.y + (speed + gravity * time * -1) * time
	elif time >= 0:
		position.y = pos
		current_state = States.IDLE
		Events.emit_signal("is_on_air", false)
		if not logNode.position.x + basePosition.x == position.x:
			Events.emit_signal("player_drowned")
			print("Rip crabby")
			Events.emit_signal("lose_damage", false)
			current_state = States.DROWNING
			Utils.playSoundFile(self,"res://Assets/Audio/SFX/splash1.wav","SFX",-12)
		

func can_jump(value: bool):
	canJump = value
	
func lose_damage(value: bool):
	loseDamage = value

func handle_position():
	position = logNode.position + basePosition

func _process(delta):
	var char_available = get_node("../").isCharacterAvailable("frog")
	if visible != char_available:
		visible = char_available
		collider.monitoring = visible

	var commands = InputHandler.getCommands()
	match current_state:
		States.IDLE:
			handle_position()
			if len(commands) > 0:
				if commands.find("jump") != -1 and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
					jump()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "jump" and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
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

func onTreeDetected(area):
	if z_index < 5:
		Events.emit_signal("collision_with_tree",area)
