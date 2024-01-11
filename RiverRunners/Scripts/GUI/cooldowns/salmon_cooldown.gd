extends Control

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("dashing", dashing)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dashing():
	get_node("AnimationPlayer").play("dashed")
