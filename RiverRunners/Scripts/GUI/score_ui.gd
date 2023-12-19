extends Control

var to_count = true
var time
var points

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0.0
	points = 0.0

func counting():
	to_count = true

func stop_counting():
	to_count = false

func get_points():
	return points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if to_count:
		time += delta
		points = snapped(time, 1)
		$Panel/Label2.text = str(points)
