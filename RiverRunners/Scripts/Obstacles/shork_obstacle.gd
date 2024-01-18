extends Area2D

var sprite
var timer
var player_position = Vector2.ZERO
var attacked = false
var playerdetector

enum States {UNDERWATER_IDLE, EMPTY_IDLE, BITE, PAUSED}
var current_state = States.EMPTY_IDLE
var previous_state = States.EMPTY_IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite2D
	sprite.connect("animation_looped", _on_animated_sprite_2d_animation_looped)
	Events.connect("player_position",onGetPlayerPosition)
	Events.connect("player_speed",onGetPlayerSpeed)


	playerdetector = get_node("../playerdetetor")
	playerdetector.connect("area_entered",onPlayerDetected)
	#self.connect("area_entered",onAreaEntered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		States.UNDERWATER_IDLE:
			sprite.play("underwater_idle")
			monitorable = true

		States.EMPTY_IDLE:
			sprite.play("empty_idle")
			monitorable = false

		States.BITE:
			#print("Shork frame: ", sprite.frame)
			if sprite.frame < 8:
				monitorable = true
			else:
				monitorable = false

		States.PAUSED:
			pass

func onPause():
	previous_state = current_state
	current_state = States.PAUSED

func onResume():
	current_state = previous_state

func idleLooped():
	var distance = global_position.distance_to(player_position)
	if randf() - distance / 700 > 0.5:
		attack()

func onPlayerDetected(area):
	attack()

func attack():
	if current_state == States.UNDERWATER_IDLE:
		sprite.play("bite")
		current_state = States.BITE
		attacked = true

func onGetPlayerPosition(new_position):
	player_position = new_position
	if not attacked and global_position.distance_to(player_position) < 1200 and current_state == States.EMPTY_IDLE:
		current_state = States.UNDERWATER_IDLE
		sprite.play("underwater_idle")

func onGetPlayerSpeed(speed):
	playerdetector.position = Vector2(speed*-50,speed*25)
	get_node("CollisionPolygon2D").position = Vector2(speed*10,speed*-5)

func _on_animated_sprite_2d_animation_looped():
	if sprite.animation == "underwater_idle":
		if current_state != States.PAUSED:
			idleLooped()
	elif sprite.animation == "bite":
		sprite.play("underwater_idle")
		current_state = States.EMPTY_IDLE

