extends Area2D

var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite2D
	#self.connect("area_entered",onAreaEntered)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.play("idle")

#func onAreaEntered(area):
#	if area.has_method("tentacle_collided"):
#		area.tentacle_collided(sprite)