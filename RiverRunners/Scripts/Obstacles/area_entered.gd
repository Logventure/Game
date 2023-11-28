extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func log_collided():
	$AnimatedSprite2D.visible = false

func crab_collided():
	pass

func stone_collided():
	pass
