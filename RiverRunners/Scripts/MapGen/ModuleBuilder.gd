extends Node
class_name ModuleBuilder

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#reads a text file and returns map modules from it
static func buildMapModulesFromFile(path: String, componentPathMap: Dictionary, tilesize):
	var modules = []
	var componentMap = loadComponentsFromMap(componentPathMap)
	var file = FileAccess.open(path,FileAccess.READ)
	var line = file.get_line()
	var difficulty = 0
	var group = []
	var lines = []
	while file.get_position() < file.get_length():
		if not line == "" and not line.begins_with("#"):
			if line == "{":
				lines = []
			elif line == "}":
				modules.append(buildModule(lines, difficulty, group, componentMap, tilesize))
				group = []
			elif line.begins_with("Difficulty: "):
				difficulty = line.to_int()
			elif line.begins_with("Group: "):
				var groups = line.split(",")
				for g in groups:
					group.append(g.to_int())
			else:
				lines.append(line)
		
		line = file.get_line()
		
	return modules
	

#returns a dictionary that includes, by this order: module(Node2D), difficulty, group, length, entry lanes, exit lanes
static func buildModule(lines,difficulty,group,componentMap, tilesize):
	var module = Node2D.new()

	for i in range(0,len(lines),1):
		for j in range(0,len(lines[i])):
			if componentMap.has(lines[i].substr(j,1)):
				var component = componentMap[lines[i].substr(j,1)].instantiate()
				component.position = Utils.gridRelativePosition(Vector2(0,0),j-2,len(lines) - 1 - i,tilesize)
				component.z_index+=j*5
				module.add_child(component)

	module.z_index += 1
	return {"module": module, "difficulty": difficulty, "group": group, "length": len(lines), "entry_lanes": freeLanes(lines[len(lines) - 1]), "exit_lanes": freeLanes(lines[0])}

				
	
static func loadComponentsFromMap(componentPathMap):
	var components = {}
	for key in componentPathMap:
		components[key] = load(componentPathMap[key])
	return components
	
	
static func freeLanes(line: String):
	var lanes = []
	for i in range(0,len(line)):
		if line.substr(i,1) == "-":
			lanes.append(i+1)
	return lanes
