extends AnimatedSprite2D

var animal
var pos = 0
var base_gravity = 800
var dive_gravity = 3000
var gravity = 800
var time = 0
var speed = 500
var delay = 0.001
var current_jump_position = 0
var current_jump_speed = 0
var is_jumping = false
var logNode
var basePosition = position
var canJump = true
var loseDamage = true
var canBlock = true
var timer
var base_z_index = 0

@onready var collider = get_node("CrabCollider")
var collider_pos

var is_over_tree = false
var detected_tree


enum States {IDLE, JUMPING, BLOCKING, DESTROYING, DROWNING, TAKE_DAMAGE, PAUSED}
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

	collider.connect("area_entered",onTreeDetected)
	collider.connect("area_exited",onTreeExited)
	collider_pos = collider.position

	base_z_index = z_index

func jump():
	if canJump:
		current_state = States.JUMPING
		time = -1*delay
		pos = logNode.position.y + basePosition.y
		loseDamage = true
		gravity = base_gravity

func handle_jump(delta): 
	if time <= 0 and time + delta >= 0:
		Utils.playSoundFile(self,"res://Assets/Audio/SFX/jump.wav","SFX",-12)
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

		print("Crab - Collider position: ", collider.position, " - collider_pos: ", collider_pos, " - current_jump_position: ", current_jump_position, " - pos: ", pos)

		if is_over_tree and position.y - pos > -50 and detected_tree != null:
			Events.emit_signal("collision_with_tree",detected_tree)

	elif time >= 0:
		position.y = pos
		current_jump_position = position.y
		current_state = States.IDLE
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

func shield():
	current_state = States.BLOCKING
	Events.emit_signal("crab_shield")
	Events.emit_signal("blocking")
	play("block")
	Utils.playSoundFile(self,"res://Assets/Audio/SFX/crab_shield.wav","SFX",-6)
	createTimer()

func createTimer():
	canBlock = false
	timer = Timer.new()
	add_child(timer)

	timer.wait_time = 7.5
	timer.one_shot = true
	timer.start()

	timer.connect("timeout", onTimerTimeout)

func onTimerTimeout():
	canBlock = true
	timer.queue_free()

func _process(delta):
	var char_available = get_node("../").isCharacterAvailable("crab")
	if visible != char_available:
		visible = char_available
		collider.monitoring = visible

	if get_node("../").isCharacterAvailable("crab"):
		var commands = InputHandler.getCommands()
		match current_state:
			States.IDLE:
				handle_position()
				if len(commands) > 0:
					if commands.find("jump") != -1 and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						jump()
					if commands.find("shield") != -1 and get_node("../").isCharacterAvailable("crab") and canBlock:
						shield()
				else:
					var last_input = InputHandler.getLastInput()
					if last_input == "jump" and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						jump()
						#InputHandler.clearLastInput() #clearing would prevent others from jumping
					if last_input == "shield" and get_node("../").isCharacterAvailable("crab") and canBlock:
						shield()
						InputHandler.clearLastInput()

			States.JUMPING:
				if len(commands) > 0:
					if commands.find("jump") != -1 and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						if time > 0.3:
							gravity = dive_gravity
				handle_jump(delta)

			States.BLOCKING:
				handle_position()
				Events.emit_signal("can_jump", false)

			States.DESTROYING:
				handle_position()

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
	if timer != null:
		timer.paused = true
		Events.emit_signal("pauseCrabCooldown")

func onResume():
	current_state = previous_state
	if timer != null:
		timer.paused = false
		Events.emit_signal("resumeCrabCooldown")

func _on_animation_finished():
	pass

func destroyObstacle():
	Utils.playSoundFile(self,"res://Assets/Audio/SFX/destroy_rock.wav","SFX",-6)
	current_state = States.DESTROYING

func _on_animation_looped():
	if animation == "block":
		if current_state == States.DESTROYING:
			play("destroy")
		else:
			play("idle")
			current_state = States.IDLE
			Events.emit_signal("can_jump", true)
	elif animation == "destroy":
		play("idle")
		current_state = States.IDLE
		Events.emit_signal("can_jump", true)
	elif animation == "jump":
		play("idle")


func onTreeDetected(area):
	is_over_tree = true
	detected_tree = area
	if position.y - pos > -75:
		Events.emit_signal("collision_with_tree",area)

func onTreeExited(area):
	is_over_tree = false