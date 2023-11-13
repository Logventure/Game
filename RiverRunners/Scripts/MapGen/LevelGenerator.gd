extends Node2D


#these position values represent a section of the river (how many tiles away they are from the starting point)
var currentPosition = 0 #current section the front of the log is in
var currentModule = 0
var lastGeneratedPosition = 8 #last section that was generated, initial value indicates where to start adding obstacles
var lastEnvironmentPosition = -10
var possibleLanes = [1,2,3,4,5]

var mapModuleTemplates = [] #pre-made obstacle templates are stored here
var environmentTemplates = [] #pre-made environment templates are stored here
var mapModules = [] #stores current map sections, oldest to newest
var environmentModules = [] #stores current environment sections, oldest to newest

@export var minGeneratedTiles = 10 #minimum number of tiles that should always be kept on the map
@export var tilesize = 380 #width of each tile in pixels

@export var level_difficulty = 0
@export var level_groups = []

var generateObstacles = true

var obstacleQueue = ["res://MapGeneration/Modules/module1.tscn"] #if there are paths here, those modules will be added before the randomizer is used

# Called when the node enters the scene tree for the first time.
func _ready():
	#loads all scenes available on the Modules and Environment folders
	var mapinfo = loadModuleInfoFromFile("res://TextFiles/moduleinfo.txt")
	environmentTemplates.append_array(loadMapModuleTemplates("res://MapGeneration/Environment/",mapinfo))
	mapModuleTemplates.append_array(loadMapModuleTemplates("res://MapGeneration/Modules/",mapinfo))
	mapModuleTemplates.append_array(ModuleBuilder.buildMapModulesFromFile("res://TextFiles/moduledescription.txt", loadJsonFromFile("res://TextFiles/componentmap.txt"), tilesize))

	while lastEnvironmentPosition < minGeneratedTiles:
		addEnvironment(lastEnvironmentPosition,2)

	#connects to player position signal
	Events.connect("player_position", onUpdateCurrentPosition)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	#add new modules and clear unnecessary ones
	while lastGeneratedPosition - currentPosition < minGeneratedTiles and generateObstacles:
		addMapModule(lastGeneratedPosition,1,level_difficulty,level_groups)


	while lastEnvironmentPosition - currentPosition < minGeneratedTiles:
		addEnvironment(lastEnvironmentPosition,1)
	

	clearOldModules()
	

#to be called with signals

func disableObstacles():
	generateObstacles = false

func enableObstacles():
	if not generateObstacles and lastGeneratedPosition < currentPosition + minGeneratedTiles:
		lastGeneratedPosition = currentPosition + minGeneratedTiles
	generateObstacles = true

func addToQueue(array):
	obstacleQueue.append_array(array)

func clearOldModules():
	if len(mapModules) > 0:
		while mapModules[0].position.distance_to(Utils.gridRelativePosition(Vector2(),0,currentPosition,tilesize)) > minGeneratedTiles * tilesize and len(mapModules) > 1:
			clearOldestModule(mapModules)
	if len(environmentModules) > 0:
		while environmentModules[0].position.distance_to(Utils.gridRelativePosition(Vector2(),0,currentPosition,tilesize)) > minGeneratedTiles * tilesize and len(environmentModules) > 1:
			clearOldestModule(environmentModules)


func onUpdateCurrentPosition(pos):
	currentPosition = position.distance_to(pos)/Vector2(tilesize/2,tilesize/-4).length()
	updateCurrentModule(pos)


func updateCurrentModule(pos):
	currentModule = getCurrentModule(pos)
	if currentModule >= 0:
		z_index = -1 * mapModules[currentModule].z_index

		


#loads all scenes available on the Modules folders and returns them in a list
#will add more later
func loadMapModuleTemplates(path: String, modulesInfo = {}):
	var templates = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				print("Loading Map Module: " + file_name)
				var full_path = path + file_name
				var module = {"module" : load(full_path), "path" : full_path}
				if modulesInfo.has(full_path):
					module.merge(modulesInfo[full_path])
				else:
					#invalid module, will not be used
					module.merge({"difficulty": 1, "group": [-1], "length": 1, "entry_lanes": [], "exit_lanes":[]})
				templates.append(module)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return templates


func loadJsonFromFile(path: String):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		return json_as_dict	
	return {}

#loads the modules info (loadJson didn't work correctly in this case)
func loadModuleInfoFromFile(path: String):
	var dict = {}
	var file = FileAccess.open(path,FileAccess.READ)
	var line = file.get_line().strip_edges()
	var modulepath = ""
	var difficulty = 0
	var group = []
	var length = 0
	var entry_lanes = []
	var exit_lanes = []

	while file.get_position() < file.get_length():
		if not line == "" and not line.begins_with("#"):
			if line == "{":
				modulepath = ""
				difficulty = 0
				group = []
				length = 0
				entry_lanes = []
				exit_lanes = []
			elif line == "}":
				dict[modulepath] = {"difficulty" : difficulty, "group" : group, "length" : length, "entry_lanes" : entry_lanes, "exit_lanes" : exit_lanes}
			elif line.begins_with("Path: "):
				modulepath = line.substr(6).strip_edges()
			elif line.begins_with("Difficulty: "):
				difficulty = line.to_int()
			elif line.begins_with("Group: "):
				var groups = line.split(",")
				for g in groups:
					group.append(g.to_int())
			elif line.begins_with("Length: "):
				length = line.to_int()
			elif line.begins_with("Entry Lanes: "):
				var lanes = line.split(",")
				for l in lanes:
					entry_lanes.append(l.to_int())
			elif line.begins_with("Exit Lanes: "):
				var lanes = line.split(",")
				for l in lanes:
					exit_lanes.append(l.to_int())
		line = file.get_line()
		
	return dict

#returns a random module from the loaded templates
func randomizeModule(possibleModules,difficulty = 0,possibleGroups: Array = []): 
	var randomModule = possibleModules[randi() % len(possibleModules)]
	if randomModule["difficulty"] <= difficulty or difficulty < 1:	
		for group in randomModule["group"]:
			if group < 0:
				return randomizeModule(possibleModules,difficulty,possibleGroups)
			if possibleGroups.has(group) or possibleGroups == []:
				return randomModule
	return randomizeModule(possibleModules,difficulty,possibleGroups)
	


#adds a new module to the map (prevPosition is usually the last generated position, steps is how many tiles away the module should be placed)
func addMapModule(prevPosition: int, steps: int = 1, difficulty = 0, possibleGroups = []):
	var newPosition = Vector2(position.x + (prevPosition + steps) * tilesize/2, position.y + (prevPosition + steps) * tilesize / -4)
	var randomModule
	if not obstacleQueue == []:
		for module in mapModuleTemplates:
			if module.has("path"):
				if module["path"] == obstacleQueue[0]:
					randomModule = module
					obstacleQueue.remove_at(0)
					break
	else:
		randomModule = randomizeModule(mapModuleTemplates,difficulty,possibleGroups)
		while Utils.arrayHasItemsInCommon(randomModule["entry_lanes"],possibleLanes) < 2:
			randomModule = randomizeModule(mapModuleTemplates,difficulty,possibleGroups)


	possibleLanes = randomModule["exit_lanes"]
	var newMapModule
	if randomModule["module"] is PackedScene:
		newMapModule = randomModule["module"].instantiate()
	else:
		newMapModule = randomModule["module"].duplicate()

	increaseObjectsZindex(mapModules)

	lastGeneratedPosition = prevPosition + randomModule["length"]
	newMapModule.position = newPosition
	mapModules.append(newMapModule)
	add_child(newMapModule)
	

func clearOldestModule(moduleList):
	if len(moduleList) > 0:
		moduleList[0].queue_free()
		moduleList.remove_at(0)


func addEnvironment(prevPosition: int, steps: int = 1):
	var newPosition = Vector2(position.x + (prevPosition + steps) * tilesize/2, position.y + (prevPosition + steps) * tilesize / -4)
	var randomModule = randomizeModule(environmentTemplates)
	var newMapEnvironment
	if randomModule["module"] is PackedScene:
		newMapEnvironment = randomModule["module"].instantiate()
	else:
		newMapEnvironment = randomModule["module"].duplicate()

	newMapEnvironment.position = newPosition
	newMapEnvironment.z_index -= 200		#provavelmente deve mudar
	increaseObjectsZindex(environmentModules)
	environmentModules.append(newMapEnvironment)
	add_child(newMapEnvironment)
	lastEnvironmentPosition = prevPosition + randomModule["length"]

	
func increaseObjectsZindex(array,value=1):
	for object in array:
		object.z_index+=value
	
#just for testing purposes
func moveLog(delta):
	var log = get_node("LogSprite")
	log.position = Vector2(log.position.x + delta * tilesize / 2, log.position.y + delta * tilesize / -4)
	return log.position

func getCurrentModule(pos):
	var module_index = 0
	if mapModules.size() < 1:
		return -1
	for module in mapModules:
		var module_distance = position.distance_to(module.position)/Vector2(tilesize/2,tilesize/-4).length()
		if module_distance - currentPosition > 0:
			return module_index
		module_index += 1
	return -1
