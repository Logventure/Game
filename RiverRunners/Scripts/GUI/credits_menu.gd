extends Control

@onready var animation = $AnimationPlayer
@onready var timer = $Timer
var onCredits = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("go_from_main_menu_to_credits", credits)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if onCredits:
		$Label.position.y -= 2.5 * delta
		$Label2.position.y -= 2.5 * delta
		$Label3.position.y -= 2.5 * delta
		$Label4.position.y -= 2.5 * delta
		$Label5.position.y -= 2.5 * delta
		$Label6.position.y -= 2.5 * delta
		$Label7.position.y -= 2.5 * delta
		$Label8.position.y -= 2.5 * delta
		$Label9.position.y -= 2.5 * delta
		$Label10.position.y -= 2.5 * delta

func credits():
	timer.start(34)
	animation.play("credits_loop")
	onCredits = true

func _on_timer_timeout():
	onCredits = false
	$Label.position.y = 1081
	$Label2.position.y = 1350
	$Label3.position.y = 1430
	$Label4.position.y = 1430
	$Label5.position.y = 2320
	$Label6.position.y = 2400
	$Label7.position.y = 2400
	$Label8.position.y = 3170
	$Label9.position.y = 3260
	$Label10.position.y = 3260
	Events.emit_signal("go_from_credits_to_main_menu")