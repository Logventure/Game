extends CPUParticles2D

var player_speed
var basespread
# Called when the node enters the scene tree for the first time.
func _ready():
	basespread = spread
	Events.connect("player_speed", onUpdatePlayerSpeed)
	Events.connect("pause_game", onPause)
	Events.connect("resume_game", onResume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onUpdatePlayerSpeed(speed):
	player_speed = speed
	spread = basespread + player_speed * player_speed

func onPause():
	emitting = false


func onResume():
	emitting = true