extends Panel

@onready var sprite = $health_bar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(whole):
	if whole: sprite.frame = 0
	else:
		if $health_bar.visible == true:
			explode()
		#queue_free()

func explode():
	var current_texture = $health_bar.texture
	var width = current_texture.get_width()
	var height = current_texture.get_height()
	var polygon_points = PackedVector2Array([Vector2(-1*width/2,-1*height/2),Vector2(width/2,-1*height/2),Vector2(width/2,height/2),Vector2(-1*width/2,height/2)])
	var explosion_polygon = load("res://Scripts/Obstacles/explode_obstacle.gd").new($health_bar.position,current_texture,Vector2(width/2,height/2))
	explosion_polygon.set_polygon(polygon_points)
	explosion_polygon.scale = $health_bar.scale
	$health_bar.visible = false
	add_child(explosion_polygon)
	explosion_polygon.explode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
