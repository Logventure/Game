extends AnimatedSprite2D

var animal
var logNode
var basePosition = position
var targetPosition = position
var move_speed = 0.8
var push_position_right = Vector2(55,91)
var push_position_left = Vector2(-99,33)
var base_z_index = -40
var canDash = true
var timer

enum States{IDLE_SWIM,IDLE_DIVE,IDLE_SURFACE,PUSH_LEFT,PUSH_RIGHT,DASHING_LEFT,DASHING_RIGHT,PUSH_RETURN, PAUSED}

var current_state = States.IDLE_SWIM
var previous_state = States.IDLE_SWIM

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")

	Events.connect("on_dialog_start", onPause)
	Events.connect("on_dialog_end", onResume)

	Events.connect("pause_game", onPause)
	Events.connect("resume_game", onResume)
	
func handle_position(delta):
	targetPosition = logNode.position + basePosition
	position = position.lerp(targetPosition,delta*move_speed)

func dashLeft():
	current_state = States.PUSH_LEFT
	targetPosition = logNode.position + push_position_right
	createTimer()

func dashRight():
	current_state = States.PUSH_RIGHT
	targetPosition = logNode.position + push_position_left
	createTimer()

func createTimer():
	canDash = false
	timer = Timer.new()
	add_child(timer)

	timer.wait_time = 1.9
	timer.one_shot = true
	timer.start()

	timer.connect("timeout", onTimerTimeout)

func onTimerTimeout():
	canDash = true
	timer.queue_free()

func _process(delta):
	var char_available = get_node("../").isCharacterAvailable("salmon")
	if visible != char_available:
		visible = char_available

	var commands = InputHandler.getCommands()
	match current_state:
		States.IDLE_SWIM:
			handle_position(delta)
			play("swim_idle")
			if randf() < 0.0001:
				current_state = States.IDLE_DIVE

			if len(commands) > 0:
				if commands.find("dash_left") != -1 and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashLeft()
				elif commands.find("dash_right") != -1 and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashRight()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "dash_left" and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashLeft()
					InputHandler.clearLastInput()
				if last_input == "dash_right" and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashRight()
					InputHandler.clearLastInput()

		States.IDLE_DIVE:
			handle_position(delta)
			play("dive")
			if len(commands) > 0:
				if commands.find("dash_left") != -1 and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashLeft()
				elif commands.find("dash_right") != -1 and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashRight()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "dash_left" and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashLeft()
					InputHandler.clearLastInput()
				if last_input == "dash_right" and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashRight()
					InputHandler.clearLastInput()

		States.IDLE_SURFACE:
			handle_position(delta)
			play("surface")
			if len(commands) > 0:
				if commands.find("dash_left") != -1 and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashLeft()
				elif commands.find("dash_right") != -1 and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashRight()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "dash_left" and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashLeft()
					InputHandler.clearLastInput()
				if last_input == "dash_right" and get_node("../").isCharacterAvailable("salmon") and canDash:
					dashRight()
					InputHandler.clearLastInput()

		States.PUSH_LEFT:
			play("push-left")
			Events.emit_signal("dashing")
			if frame >= 1:
				get_node("../").dashLeft()
				var soundfile = ["res://Assets/Audio/SFX/dash-1.wav", "res://Assets/Audio/SFX/dash-2.wav", "res://Assets/Audio/SFX/dash-3.wav"].pick_random()
				Utils.playSoundFile(self,soundfile,"SFX",0,true)
				current_state = States.DASHING_LEFT
				z_index = 2
			else:
				targetPosition = logNode.position + push_position_right
				position = position.lerp(targetPosition, delta * 8 + position.distance_to(targetPosition)*0.001*delta)

		States.PUSH_RIGHT:
			play("push-right")
			Events.emit_signal("dashing")
			if frame >= 1:
				get_node("../").dashRight()
				var soundfile = ["res://Assets/Audio/SFX/dash-1.wav", "res://Assets/Audio/SFX/dash-2.wav", "res://Assets/Audio/SFX/dash-3.wav"].pick_random()
				Utils.playSoundFile(self,soundfile,"SFX",0,true)
				current_state = States.DASHING_RIGHT
			else:
				targetPosition = logNode.position + push_position_left
				position = position.lerp(targetPosition, delta * 8 + position.distance_to(targetPosition)*0.001*delta)

		States.DASHING_LEFT:
			if frame <= 3:
				position = logNode.position + push_position_right
			else:
				handle_position(delta)
				z_index = base_z_index
			
		States.DASHING_RIGHT:
			if frame <= 3:
				position = logNode.position + push_position_left
			else:
				handle_position(delta)
				z_index = base_z_index


		States.PUSH_RETURN:
			handle_position(delta)
			play("surface")
		
		States.PAUSED:
			pass

func onPause():
	previous_state = current_state
	print("current state: ", current_state)
	current_state = States.PAUSED
	if timer != null:
		timer.paused = true
		Events.emit_signal("pauseSalmonCooldown")
		pause()	

func onResume():
	current_state = previous_state
	if timer != null:
		timer.paused = false
		Events.emit_signal("resumeSalmonCooldown")
		play()

func _on_animation_finished():
	match current_state:
		States.IDLE_DIVE:
			play("surface")
			current_state = States.IDLE_SURFACE

		States.IDLE_SURFACE:
			play("swim_idle")
			current_state = States.IDLE_SWIM

		States.PUSH_LEFT:
			play("surface")
			current_state = States.PUSH_RETURN
			z_index = base_z_index

		States.PUSH_RIGHT:
			play("surface")
			current_state = States.PUSH_RETURN

		States.DASHING_LEFT:
			play("surface")
			current_state = States.PUSH_RETURN
			z_index = base_z_index

		States.DASHING_RIGHT:
			play("surface")
			current_state = States.PUSH_RETURN
			z_index = base_z_index

		States.PUSH_RETURN:
			play("swim_idle")
			current_state = States.IDLE_SWIM
			