extends Area2D

@export var lane_offset = 0
var collision_count = 0
var isFree = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered",onAreaEntered)
	self.connect("area_exited",onAreaExited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func onAreaEntered(area):
	collision_count += 1
	updateLaneStatus()


func onAreaExited(area):
	collision_count -= 1
	updateLaneStatus()

func updateLaneStatus():
	if collision_count == 0 and !isFree:
		isFree = true
		Events.emit_signal("is_lane_free", lane_offset, isFree)
	if collision_count > 0 and isFree:
		isFree = false
		Events.emit_signal("is_lane_free", lane_offset, isFree)
