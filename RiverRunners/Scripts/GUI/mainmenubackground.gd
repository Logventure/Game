extends AnimatedSprite2D

enum States{SLEEP,AWAKE}
var current_state = States.SLEEP

var poke_count: int = 0

var sounds = ["res://Assets/Audio/SFX/UI/boing1.wav", "res://Assets/Audio/SFX/UI/boing2.wav", "res://Assets/Audio/SFX/UI/boing3.wav"]
var last_sound_played = "res://Assets/Audio/SFX/UI/boing1.wav"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.button_down.connect(onJustinPressed)
	#var clickmask = Image.load_from_file("res://Assets/UI/Main Menu/JustinWakeUp2.png")
	#$TextureButton.texture_click_mask.create_from_image_alpha(clickmask)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("controller_shield"):
		onJustinPressed()

	match current_state:
		States.SLEEP:
			$Justin.position = Vector2(12.917,38.083)

		States.AWAKE:
			$Justin.position = Vector2(11.9,56.1)

func onJustinPressed():
	current_state = States.AWAKE
	if current_state == States.SLEEP:
		$Justin.play("awake")
	elif current_state == States.AWAKE:
		$Justin.stop()
		$Justin.play("awake")
	$Justin.position = Vector2(11.9,56.1)
	if visible:
		var sound = sounds.pick_random()
		while sound == last_sound_played and len(sounds) > 1:
			sound = sounds.pick_random()
		Utils.playSoundFile(self,sound,"SFX",-6)
		last_sound_played = sound
		poke_count += 1
		SteamController.add_to_statistic("beaver_total_poke", 1)
		print("poked!")

	if poke_count > 20:
		SteamController.set_achievement("poke_beaver_20")



func _on_justin_animation_looped():
	if $Justin.animation == "awake":
		$Justin.play("sleep")
		poke_count = 0
		current_state = States.SLEEP
		$Justin.position = Vector2(12.917,38.083)
