extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func log_collided():
	explode()
	#get_node("../").queue_free()

func crab_collided():
	explode()
	#get_node("../").queue_free()

func stone_collided():
	pass

func explode():
	var current_texture = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation,$AnimatedSprite2D.frame)
	var width = current_texture.get_width()
	var height = current_texture.get_height()
	var polygon_points = PackedVector2Array([Vector2(-1*width/2,-1*height/2),Vector2(width/2,-1*height/2),Vector2(width/2,height/2),Vector2(-1*width/2,height/2)])
	var explosion_polygon = load("res://Scripts/Obstacles/explode_obstacle.gd").new($AnimatedSprite2D.position,current_texture,Vector2(width/2,height/2))
	explosion_polygon.set_polygon(polygon_points)
	explosion_polygon.scale = $AnimatedSprite2D.scale
	#$AnimatedSprite2D.visible = false
	#$CollisionPolygon2D.set_deferred("disabled",true)
	#$CollisionPolygon2D.queue_free()
	add_child(explosion_polygon)
	explosion_polygon.explode()

