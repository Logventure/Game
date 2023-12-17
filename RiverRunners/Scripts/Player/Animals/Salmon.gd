extends AnimatedSprite2D

var animal
var logNode
var basePosition = position
var targetPosition = position
var move_speed = 0.8
var push_position_right = Vector2(55,91)
var push_position_left = Vector2(-99,33)


enum States{IDLE_SWIM,IDLE_DIVE,IDLE_SURFACE,PUSH_LEFT,PUSH_RIGHT,DASHING_LEFT,DASHING_RIGHT,PUSH_RETURN}

var current_state = States.IDLE_SWIM

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	
func handle_position(delta):
	targetPosition = logNode.position + basePosition
	position = position.lerp(targetPosition,delta*move_speed)

func dashLeft():
	current_state = States.PUSH_LEFT
	targetPosition = logNode.position + push_position_right

func dashRight():
	current_state = States.PUSH_RIGHT
	targetPosition = logNode.position + push_position_left

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
				if commands.find("dash_left") != -1 and get_node("../").isCharacterAvailable("salmon"):
					dashLeft()
				elif commands.find("dash_right") != -1 and get_node("../").isCharacterAvailable("salmon"):
					dashRight()
			else:
				var last_input = InputHandler.getLastInput()
				if last_input == "dash_left" and get_node("../").isCharacterAvailable("salmon"):
					dashLeft()
					InputHandler.clearLastInput()
				if last_input == "dash_right" and get_node("../").isCharacterAvailable("salmon"):
					dashRight()
					InputHandler.clearLastInput()

		States.IDLE_DIVE:
			handle_position(delta)
			play("dive")

		States.IDLE_SURFACE:
			handle_position(delta)
			play("surface")

		States.PUSH_LEFT:
			z_index = 2
			play("push-left")
			if frame >= 1:
				get_node("../").dashLeft()
				current_state = States.DASHING_LEFT
			else:
				targetPosition = logNode.position + push_position_right
				position = position.lerp(targetPosition, delta * 7 + position.distance_to(targetPosition)*0.001*delta)

		States.PUSH_RIGHT:
			play("push-right")
			if frame >= 1:
				get_node("../").dashRight()
				current_state = States.DASHING_RIGHT
			else:
				targetPosition = logNode.position + push_position_left
				position = position.lerp(targetPosition, delta * 7 + position.distance_to(targetPosition)*0.001*delta)

		States.DASHING_LEFT:
			if frame <= 3:
				position = logNode.position + push_position_right
			else:
				handle_position(delta)
			
		States.DASHING_RIGHT:
			if frame <= 3:
				position = logNode.position + push_position_left
			else:
				handle_position(delta)


		States.PUSH_RETURN:
			handle_position(delta)
			play("surface")

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
			z_index = -40

		States.PUSH_RIGHT:
			play("surface")
			current_state = States.PUSH_RETURN

		States.DASHING_LEFT:
			play("surface")
			current_state = States.PUSH_RETURN
			z_index = -40

		States.DASHING_RIGHT:
			play("surface")
			current_state = States.PUSH_RETURN
			z_index = -40

		States.PUSH_RETURN:
			play("swim_idle")
			current_state = States.IDLE_SWIM
	
	