extends Area2D

var collider 
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	collider = $CollisionPolygon2D
	Events.connect("crab_shield", shield)
	self.connect("area_entered", onAreaEntered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shield():
	collider.disabled = false
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.5)
	timer.connect("timeout", onTimerTimeout)
	add_child(timer)
	timer.start()


func onAreaEntered(area):
	get_node("../").play("block")
	if area.has_method("crab_collided"):
		area.crab_collided()

func onTimerTimeout():
	collider.disabled = true
	if is_instance_valid(timer):
		timer.queue_free()
