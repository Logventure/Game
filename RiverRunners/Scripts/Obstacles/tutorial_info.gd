extends Node2D

var area_count = 0

var text_base_position = Vector2.ZERO
var time = 0

@export var action = "jump"

var cooldown = 0

var time_since_completed = 0

enum States {IDLE, COMPLETED, HIDDEN}
var current_state = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	text_base_position = $Text.position

	$Area2D.connect("area_entered",_on_area_2d_area_entered)
	$Area2D.connect("area_exited",_on_area_2d_area_exited)

	match action:
		"shield":
			cooldown = 7
	
	
	time_since_completed = cooldown + 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	var commands = InputHandler.getCommands()
	match current_state:
		States.IDLE:
			if time_since_completed < 0.3:
				$Text.modulate.a = time_since_completed * 2 + 0.4
				time_since_completed += delta
			else:
				$Text.modulate.a = 1

			$Text.position.y = text_base_position.y + sin(time * 2) * 20
			if len(commands) > 0:
				if commands.find(action) != -1:
					if area_count > 0:
						completed()
						current_state = States.COMPLETED
					elif cooldown > 0:
						current_state = States.HIDDEN
						time_since_completed = 0

		States.COMPLETED:
			time_since_completed += delta
			if time_since_completed > 1:
				time_since_completed = 1
			if $Text.modulate.a > 0:
				$Text.modulate.a = 1 - time_since_completed
				$Text.position.y += -20 * delta

		States.HIDDEN:
			if time_since_completed < 0.3:
				$Text.modulate.a = 1 - time_since_completed * 2
			else:
				$Text.modulate.a = 0.4

			$Text.position.y = text_base_position.y + sin(time * 2) * 20

			time_since_completed += delta
			if time_since_completed > cooldown:
				current_state = States.IDLE
				time_since_completed = 0

func completed():
	$Text.modulate = Color.GREEN
	time_since_completed = 0
	Utils.playSoundFile(self,"res://Assets/Audio/SFX/tutorial_success2.wav","SFX",0,true)

func _on_area_2d_area_exited(area:Area2D):
	area_count -= 1
	if area_count < 0:
		area_count = 0

func _on_area_2d_area_entered(area:Area2D):
	area_count += 1
	if area_count < 0:
		area_count = 0
