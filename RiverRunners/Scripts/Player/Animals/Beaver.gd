extends AnimatedSprite2D

var animal
var pos = Vector2.ZERO
var gravity = 400
var time = 0
var speed = 500
var delay = 0.36
var is_jumping = false
var logNode
var basePosition = position

enum States {IDLE, JUMPING, PAUSED}
var current_state = States.IDLE
var previous_state = States.IDLE

func _ready():
	animal = Animal.new() 
	logNode = get_node("../Log")
	
func handle_position():
	if not is_jumping:
		position = logNode.position + basePosition

func _process(delta):
	var char_available = get_node("../").isCharacterAvailable("beaver")
	if visible != char_available:
		visible = char_available

	handle_position()
	
	if get_node("../").isCharacterAvailable("beaver"):
		var commands = InputHandler.getCommands()
		match current_state:
			States.IDLE:
				handle_position()
				if len(commands) > 0:
					if commands.find("jump") != -1 and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						play("dive")
				else:
					var last_input = InputHandler.getLastInput()
					if last_input == "jump" and get_node("../").isCharacterAvailable("frog") and not get_node("../").isMoving():
						play("dive")
						InputHandler.clearLastInput()



func _on_animation_looped():
	if animation == "dive":
		play("idle")
