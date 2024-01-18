extends AudioStreamPlayer

enum States {MENU, LEVELS_EASY, LEVELS_MEDIUM, LEVELS_HARD, INFINITE}
var current_state = States.MENU

var playlist = [preload("res://Assets/Audio/Music/HoliznaCC0-Level1.mp3")]


var base_volume = -12

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("changeMusic", changeMusic)
	playMusic()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playMusic():
	match current_state:
		States.MENU:
			playlist = [preload("res://Assets/Audio/Music/HoliznaCC0-Level1.mp3")]
		States.LEVELS_EASY:
			playlist = [preload("res://Assets/Audio/Music/HoliznaCC0-Level2.mp3")]
		States.LEVELS_MEDIUM:
			playlist = [preload("res://Assets/Audio/Music/HoliznaCC0-Gamer6969.mp3")]
		States.LEVELS_HARD:
			playlist = [preload("res://Assets/Audio/Music/HoliznaCC0-RedSkies.mp3")]
		States.INFINITE:
			playlist = [preload("res://Assets/Audio/Music/HoliznaCC0-RedSkies.mp3"), preload("res://Assets/Audio/Music/HoliznaCC0-SunnyAfternoon.mp3"), preload("res://Assets/Audio/Music/HoliznaCC0-Level2.mp3")]

	var file = playlist.pick_random()

	stop()
	stream = file
	bus = "Music"
	volume_db = base_volume
	play()

func changeMusic(mode):
	var old_state = current_state
	match mode:
		"MENU":
			current_state = States.MENU
		"EASY":
			current_state = States.LEVELS_EASY
		"MEDIUM":
			current_state = States.LEVELS_MEDIUM
		"HARD":
			current_state = States.LEVELS_HARD
		"INFINITE":
			current_state = States.INFINITE
 
	if old_state != current_state:
		playMusic()

func _on_finished():
	playMusic()
