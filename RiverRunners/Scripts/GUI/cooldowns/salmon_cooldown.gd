extends Control

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("dashing", dashing)
	Events.connect("pauseSalmonCooldown", pause)
	Events.connect("resumeSalmonCooldown", resume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dashing():
	get_node("AnimationPlayer").play("dashed")

func pause():
	animation.pause()

func resume():
	animation.play("dashed")
