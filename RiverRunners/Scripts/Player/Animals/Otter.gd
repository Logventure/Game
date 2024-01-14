extends AnimatedSprite2D

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
var canThrow = true
var timer

enum States {IDLE, JUMPING, DROWNING, TAKE_DAMAGE, PAUSED}
var current_state = States.IDLE
var previous_state = States.IDLE

@onready var collider = get_node("OtterCollider")
var collider_pos

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	pos = position.y
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
		var number_of_animals = 0
		if get_node("../").isCharacterAvailable("crab"):
			number_of_animals += 1
		time = -1*delay*number_of_animals
		pos = logNode.position.y + basePosition.y
		Events.emit_signal("is_on_air", true)
		loseDamage = true

func handle_jump(delta): 
	if time <= 0 and time + delta >= 0:
		Utils.playSoundFile(self,"res://Assets/Audio/SFX/jump4.wav","SFX",-12)
	time += delta
	if position.y <= pos && time >= 0:
		position.y = pos - (speed + gravity * time * -1) * time
		z_index = int((speed + gravity * time * -1) * time / 30) * 2 + 1
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
	
func throw():
	Events.emit_signal("otter_position",position)
	Events.emit_signal("throwing")
	createTimer()

func createTimer():
	canThrow = false
	timer = Timer.new()
	add_child(timer)

	timer.wait_time = 0.7
	timer.one_shot = true
	timer.start()

	timer.connect("timeout", onTimerTimeout)

func onTimerTimeout():
	canThrow = true
	timer.queue_free()

func _process(delta):
	var char_available = get_node("../").isCharacterAvailable("otter")
	if visible != char_available:
		visible = char_available
		collider.monitoring = visible

	if get_node("../").isCharacterAvailable("otter"):
		var commands = InputHandler.getCommands()
		match current_state:
			States.IDLE:
				handle_position()
				if len(commands) > 0:
					if commands.find("jump") != -1 and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						jump()
					if commands.find("throw") != -1 and get_node("../").isCharacterAvailable("otter") and canThrow:
						throw()
				else:
					var last_input = InputHandler.getLastInput()
					if last_input == "jump" and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						jump()
						InputHandler.clearLastInput()
					elif last_input == "throw" and get_node("../").isCharacterAvailable("otter") and canThrow:
						throw()
						InputHandler.clearLastInput()

			States.JUMPING:
				handle_jump(delta)
				if len(commands) > 0:
					if commands.find("throw") != -1 and get_node("../").isCharacterAvailable("otter"):
						throw()
				else:
					var last_input = InputHandler.getLastInput()
					if last_input == "throw" and get_node("../").isCharacterAvailable("otter"):
						throw()
						InputHandler.clearLastInput()

			States.DROWNING:
				current_state = States.IDLE

			States.TAKE_DAMAGE:
				pass
				

			States.PAUSED:
				pass
			

func onPause():
	previous_state = current_state
	current_state = States.PAUSED
	Events.emit_signal("pauseOtterCooldown")

func onResume():
	current_state = previous_state
	Events.emit_signal("resumeOtterCooldown")

func onTreeDetected(area):
	if z_index < 5:
		Events.emit_signal("collision_with_tree",area)
