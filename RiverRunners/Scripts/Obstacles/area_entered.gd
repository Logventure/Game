extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func tentacle_collided(sprite):
#	sprite.play("hit")

func rock_collided():
	#$AnimatedSprite2D.visible = false
	get_node("../").queue_free()

func crab_collided():
	#$AnimatedSprite2D.visible = false
	get_node("../").queue_free()

func stone_collided():
	pass
