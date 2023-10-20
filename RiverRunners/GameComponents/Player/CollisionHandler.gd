extends Area2D

var colliding = 0 #stores how many areas the log is currently colliding with
var istimercounting = false

@export var damageCooldown = 2.0
@export var continuousDamageCooldown = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered",onAreaEntered)
	self.connect("area_exited",onAreaExited)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onAreaEntered(area):
	if colliding <= 0:
		Events.emit_signal("damage_taken", 1)
		if not istimercounting:
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