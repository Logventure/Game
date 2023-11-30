extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func log_collided():
	get_node("../").queue_free()

func crab_collided():
	get_node("../").queue_free()

func stone_collided():
	pass
	#get_node("../").onAreaEntered()