extends Panel

@onready var sprite = $health_bar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(whole):
	if whole: sprite.frame = 0
	else: queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
