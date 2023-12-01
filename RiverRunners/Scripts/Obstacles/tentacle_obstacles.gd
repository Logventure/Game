extends Area2D

var sprite
var timer

enum States {IDLE, UNDERWATER_IDLE, GOING_UP, GOING_DOWN, PAUSED}
var current_state = States.IDLE
var previous_state = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite2D
	#self.connect("area_entered",onAreaEntered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		States.IDLE:
			sprite.play("idle")

		States.UNDERWATER_IDLE:
			monitorable = false

		States.GOING_UP:
			pass

		States.GOING_DOWN:
			pass

		States.PAUSED:
			pass

func onPause():
	previous_state = current_state
	current_state = States.PAUSED

func onResume():
	current_state = previous_state
			
func onAreaEntered(area):
	current_state = States.GOING_DOWN

func handle_going_down():
	sprite.play("hit")

	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	timer.connect("timeout", onTimerTimeout)
	add_child(timer)
	timer.start()

func onTimerTimeout():
	if is_instance_valid(timer):
		timer.queue_free()
	monitorable = false

func stone_collided():
	current_state = States.GOING_DOWN
	handle_going_down()

func log_collided():
	current_state = States.GOING_DOWN
	handle_going_down()


func _on_animated_sprite_2d_animation_looped():
	if sprite.animation == "hit":
		sprite.play("underwater_idle")
	elif sprite.animation == "spawn":
		sprite.play("idle")
