extends Control

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("blocking", blocked)
	Events.connect("pauseCrabCooldown", pause)
	Events.connect("resumeCrabCooldown", resume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func blocked():
	animation.play("blocking")

func pause():
	animation.pause()

func resume():
	animation.play("blocking")
