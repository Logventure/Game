extends HSlider

const FILE_MANAGEMENT_SCRIPT = preload("res://Scripts/FileManagement.gd")

@export
var bus_name: String

var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(on_value_changed)

	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	print("Master ", value)

func on_value_changed(new_value: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))
	FILE_MANAGEMENT_SCRIPT.saveMaster(new_value)

"""func set_value_changed(savedValue: float, update_visially : bool):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(savedValue))
	FILE_MANAGEMENT_SCRIPT.saveSound("Master", savedValue)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
