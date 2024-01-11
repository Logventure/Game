extends Control

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("blocking", blocked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func blocked():
	pass
	#get_node("AnimationPlayer").play("blocking")