extends Area2D

var colliding = 0 #stores how many areas the log is currently colliding with
var istimercounting = false
var time_elapsed = 0.0

@export var damageCooldown = 1.0
@export var continuousDamageCooldown = 0.5


var sprite
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered",onAreaEntered)
	self.connect("area_exited",onAreaExited)
	
	sprite = $LogSprite
	player = get_node("../")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.play("idle")
	if istimercounting:
		time_elapsed += delta
		var alpha = 0.7 - (sin(time_elapsed*12) + 1)/6
		player.modulate = Color(1,0.9,0.9,alpha)
	else:
		time_elapsed = 0.0
		player.modulate = Color(1,1,1,1.0)
	

func onAreaEntered(area):
	Events.emit_signal("log_collided")
	if colliding <= 0:
		if not istimercounting:
			Events.emit_signal("damage_taken", 1)
			if area.has_method("log_collided"):
				area.log_collided()
			get_tree().create_timer(damageCooldown).timeout.connect(onCooldownEnd)
			istimercounting = true
	colliding += 1

	
func onAreaExited(area):
	colliding += -1

func onCooldownEnd():
	if colliding > 0:
		Events.emit_signal("damage_taken", 1)
		get_tree().create_timer(continuousDamageCooldown).timeout.connect(onCooldownEnd)
		istimercounting = true
	else:
		istimercounting = false
