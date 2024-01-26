extends AnimatedSprite2D

var animal
var pos = 0
var gravity = 800
var base_gravity = 800
var dive_gravity = 3000
var time = 0
var speed = 500
var delay = 0.12
var is_jumping = false
var current_jump_position = 0
var current_jump_speed = 0
var logNode
var basePosition = position
var canJump = true
var loseDamage = true
var base_z_index = 0

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

	base_z_index = z_index

func jump():
	if canJump:
		current_state = States.JUMPING
		var number_of_animals = 0
		if get_node("../").isCharacterAvailable("crab"):
			number_of_animals += 1
		if get_node("../").isCharacterAvailable("otter"):
			number_of_animals += 1
		time = -1*delay*number_of_animals
		pos = logNode.position.y + basePosition.y
		loseDamage = true
		gravity = base_gravity

func handle_jump(delta): 
	if time <= 0 and time + delta >= 0:
		Utils.playSoundFile(self,"res://Assets/Audio/SFX/jump5.wav","SFX",-12)
		Events.emit_signal("can_jump", false)
		play("jump")
		current_jump_speed = speed
		current_jump_position = pos
	time += delta
	if position.y <= pos && time >= 0:
		current_jump_speed = current_jump_speed + gravity * delta * -1
		position.y = position.y - current_jump_speed * delta
		#position.y = pos - (speed + gravity * time * -1) * time 
		current_jump_position = position.y
		z_index = base_z_index - int((current_jump_position - pos) / 10)
		if z_index < base_z_index:
			z_index = base_z_index
		#z_index = int((speed + gravity * time * -1) * time / 30) * 2
		collider.position.y = collider_pos.y - current_jump_position + pos
	elif time >= 0:
		position.y = pos
		current_jump_position = position.y
		current_state = States.IDLE
		Events.emit_signal("can_jump", true)
		if not logNode.position.x + basePosition.x == position.x:
			Events.emit_signal("player_drowned")
			print("Rip crabby")
			Events.emit_signal("lose_damage", false)
			current_state = States.DROWNING
			$WaterParticles.emitting = true
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

	if get_node("../").isCharacterAvailable("frog"):
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
				if len(commands) > 0:
					if commands.find("jump") != -1 and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						var number_of_animals = 0
						if get_node("../").isCharacterAvailable("crab"):
							number_of_animals += 1
						if get_node("../").isCharacterAvailable("otter"):
							number_of_animals += 1
						if time > -1*delay*number_of_animals + 0.3:
							gravity = dive_gravity
				handle_jump(delta)

			States.DROWNING:
				play("empty")
				if not $WaterParticles.emitting:
					current_state = States.IDLE
					play("idle")

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
	pos = logNode.position.y + basePosition.y
	if position.y - pos > -50:
		Events.emit_signal("collision_with_tree",area)
		


func _on_animation_looped():
	if animation == "jump":
		play("idle")
