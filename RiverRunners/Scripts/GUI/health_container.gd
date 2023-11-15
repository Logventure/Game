extends HBoxContainer

@onready var healthGuiClass = preload("res://GameComponents/GUI/health_bar.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setMaxHealth(max):
	for i in range(max):
		var health_bar = healthGuiClass.instantiate()
		add_child(health_bar)

func updateHealth(currentHealth):
	var healths = get_children()

	for i in range(currentHealth):
		healths[i+1].update(true)

	for i in range(currentHealth, healths.size()-1):
		healths[i+1].update(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
