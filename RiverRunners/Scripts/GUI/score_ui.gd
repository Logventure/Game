extends Control

const FILE_MANAGEMENT_SCRIPT = preload("res://Scripts/FileManagement.gd")

var to_count = true # trocar para false e por true quando começa o nivel
var time
var points
var highest_score

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

func checkHighestScore():	
	var saved_score = FILE_MANAGEMENT_SCRIPT.loadHighestScore()
	if saved_score == null:
		saved_score = 0
	highest_score = points
	print("highest score: ", highest_score)
	if highest_score > saved_score:
		FILE_MANAGEMENT_SCRIPT.saveHighestScore(highest_score)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if to_count:
		time += delta * 3
		points = snapped(time, 1)
		$Panel/Label2.text = str(points)
		print(points)
