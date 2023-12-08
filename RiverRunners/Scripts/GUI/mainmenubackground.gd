extends AnimatedSprite2D

enum States{SLEEP,AWAKE}
var current_state = States.SLEEP

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.connect("pressed", onJustinPressed)
	$TextureButton.texture_click_mask.create_from_image_alpha(Image.load_from_file("res://Assets/UI/Main Menu/JustinWakeUp2.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		States.SLEEP:
			$Justin.position = Vector2(12.917,38.083)

		States.AWAKE:
			$Justin.position = Vector2(12.0,56.1)

func onJustinPressed():
	current_state = States.AWAKE
	$Justin.play("awake")
	$Justin.position = Vector2(12.0,56.1)



func _on_justin_animation_looped():
	if $Justin.animation == "awake":
		$Justin.play("sleep")
		current_state = States.SLEEP
		$Justin.position = Vector2(12.917,38.083)
