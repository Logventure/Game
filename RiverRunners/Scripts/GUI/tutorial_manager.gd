extends Node2D

var active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("showTutorial",setTutorial)

func setTutorial(ability: String):
	active = true
	match ability:
		"move":
			$tutorial_boxleft.setText("move_left")
			$tutorial_boxright.setText("move_right")
		"jump":
			$tutorial_boxleft.setText("jump")
			$tutorial_boxright.setText("dive")
		"dash":
			$tutorial_boxleft.setText("dash_left")
			$tutorial_boxright.setText("dash_right")

		"shield":
			$tutorial_box.setText("shield")
		"throw":
			$tutorial_box.setText("throw")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	