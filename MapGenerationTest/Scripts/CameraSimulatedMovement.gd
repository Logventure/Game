extends Camera2D

@export var moveSpeed = 50

var followPlayer = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Map/LogSprite")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("go_down"):
		position.y += moveSpeed * delta
		followPlayer = false
		
	if Input.is_action_pressed("go_up"):
		position.y += moveSpeed * -1 * delta
		followPlayer = false
		
	if Input.is_action_pressed("go_left"):
		position.x += moveSpeed * -1 * delta
		followPlayer = false
		
	if Input.is_action_pressed("go_right"):
		position.x += moveSpeed * delta
		followPlayer = false
		
	if Input.is_action_pressed("zoom_in"):
		zoom.x += 0.01
		zoom.y += 0.01
	
	if Input.is_action_pressed("zoom_out"):
		zoom.x += -0.01
		zoom.y += -0.01

	if Input.is_action_just_pressed("spacebar"):
		followPlayer = not followPlayer

	
	if(followPlayer):
		position = player.position
	
