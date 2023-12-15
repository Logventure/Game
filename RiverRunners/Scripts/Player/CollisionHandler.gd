extends Area2D

var colliding = 0 #stores how many areas the log is currently colliding with
var istimercounting = false
var time_elapsed = 0.0

@export var damageCooldown = 1.0
@export var continuousDamageCooldown = 0.5

var damage_enabled = true

var sprite
var player
var collisionSound

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered",onAreaEntered)
	self.connect("area_exited",onAreaExited)
	Events.connect("collision_with_tree",onTreeCollision)
	Events.connect("player_died",onPlayerDie)
	
	sprite = $LogSprite
	player = get_node("../")
	collisionSound = get_node("DamageSFX")

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
	if damage_enabled:
		Events.emit_signal("log_collided")
		if colliding <= 0:
			if not istimercounting:
				Events.emit_signal("damage_taken", 1)
				collisionSound.play()
				Events.emit_signal("move_to_free_lane")
				if area.has_method("log_collided"):
					area.log_collided()
				get_tree().create_timer(damageCooldown).timeout.connect(onCooldownEnd)
				istimercounting = true
		colliding += 1

	
func onAreaExited(area):
	if damage_enabled:
		colliding += -1

func onCooldownEnd():
	if colliding > 0:
		if damage_enabled:
			Events.emit_signal("damage_taken", 1)
			collisionSound.play()
			get_tree().create_timer(continuousDamageCooldown).timeout.connect(onCooldownEnd)
			istimercounting = true
	else:
		istimercounting = false

func onTreeCollision(area):
	if damage_enabled:
		Events.emit_signal("log_collided")
		if not istimercounting:
			Events.emit_signal("damage_taken", 1)
			collisionSound.play()
			if area.has_method("log_collided"):
				area.log_collided()
			get_tree().create_timer(damageCooldown).timeout.connect(onCooldownEnd)
			istimercounting = true

func onPlayerDie():
	damage_enabled = false