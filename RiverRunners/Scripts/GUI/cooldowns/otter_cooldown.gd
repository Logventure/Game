extends Control

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("throwing", throwed)
	Events.connect("pauseOtterCooldown", pause)
	Events.connect("resumeOtterCooldown", resume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func throwed():
	get_node("AnimationPlayer").play("throwing")

func pause():
	animation.pause()

func resume():
	animation.play("throwing")	
