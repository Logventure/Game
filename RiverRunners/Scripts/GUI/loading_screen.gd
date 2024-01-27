extends Node2D

enum States {OPEN, CLOSED, OPENING, CLOSING}
var current_state = States.OPEN

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("empty")

	Events.connect("show_loading_screen",close)
	Events.connect("hide_loading_screen",open)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func close():
	if current_state == States.OPEN:
		current_state = States.CLOSING
		$AnimatedSprite2D.play("close")
	if current_state == States.CLOSED:
		Events.emit_signal("loading_screen_closed")
	
func open():
	if current_state == States.CLOSED:
		current_state = States.OPENING
		$AnimatedSprite2D.play("open")
	if current_state == States.OPEN:
		Events.emit_signal("loading_screen_opened")
	

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "open":
		Events.emit_signal("loading_screen_opened")
		current_state = States.OPEN
	elif $AnimatedSprite2D.animation == "close":
		Events.emit_signal("loading_screen_closed")
		current_state = States.CLOSED