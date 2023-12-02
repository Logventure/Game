extends Polygon2D

var shard_count = 64
var shard_velocity_map = {}

var width = 0
var height = 0

var fade_factor = 0.9
var scale_factor = 1

func _init(new_position,new_texture,tex_offset):
	position = new_position
	texture = new_texture
	texture_offset = tex_offset
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	width = texture.get_width()
	height = texture.get_height()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func explode():
	#this will let us add more points to our polygon later on
	var points = polygon
	for i in range(shard_count):
		points.append(Vector2(randi()%width - width/2, randi()%height  - height/2))
	
	
	var delaunay_points = Geometry2D.triangulate_delaunay(points)
	
	if not delaunay_points:
		print("serious error occurred no delaunay points found")
	
	#loop over each returned triangle
	for index in len(delaunay_points) / 3:
		var shard_pool = PackedVector2Array()
		#find the center of our triangle
		var center = Vector2.ZERO
		
		# loop over the three points in our triangle
		for n in range(3):
			shard_pool.append(points[delaunay_points[(index * 3) + n]])
			center += points[delaunay_points[(index * 3) + n]]
			
		# adding all the points and dividing by the number of points gets the mean position
		center /= 3
		
		#create a new polygon to give these points to
		if isPointWithinPolygon(center) and randf() > 0.2:
			var shard = Polygon2D.new()
			shard.polygon = shard_pool

			shard.texture = texture
			shard.texture_offset = texture_offset
			shard.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
				
			shard_velocity_map[shard] = Vector2(0, height*2) - center #position relative to center of sprite
			shard_velocity_map[shard].x = shard_velocity_map[shard].x * 0.2
			shard_velocity_map[shard].y = shard_velocity_map[shard].y * 0.4
				
			add_child(shard)
			print(shard)
		
	#this will make our base sprite invisible
	color.a = 0
		

func reset():
	color.a = 1
	for child in get_children():
		if child.name != "Camera2D":
			child.queue_free()
	shard_velocity_map = {}
	
func isPointWithinPolygon(point):
	if point.x < polygon[0].x or point.x > polygon[1].x or point.y < polygon[0].y or point.y > polygon[2].y:
		return false
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#we wan't to chuck our traingles out from the center of the parent
	for child in shard_velocity_map.keys():
		child.position -= shard_velocity_map[child] * delta * 10
		child.rotation -= shard_velocity_map[child].x * delta * 0.2
		#apply gravity to the velocity map so the triangle falls
		shard_velocity_map[child].y -= delta * 50

		if child.scale.x > 0.01:
			child.scale = Vector2(child.scale.x - scale_factor * delta, child.scale.y - scale_factor * delta)

		var opacity = child.modulate.a - child.modulate.a * fade_factor * delta - fade_factor * delta * 0.3
		if opacity > 0.0:
			child.modulate = Color(1,1,1,opacity)
		else:
			child.modulate = Color(1,1,1,0)
