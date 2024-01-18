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
var validModules = [] 

var empty_module = {"module": Node2D.new(), "difficulty": 1, "group": 1, "length": 0, "entry_lanes": [1,2,3,4,5], "exit_lanes": [1,2,3,4,5]}

@export var minGeneratedTiles = 10 #minimum number of tiles that should always be kept on the map
@export var tilesize = 380 #width of each tile in pixels

@export var level_difficulty = 0
@export var level_groups = []

var generateObstacles = true

var obstacleQueue = [] #if there are paths here, those modules will be added before the randomizer is used

# Called when the node enters the scene tree for the first time.
func _ready():
	#loads all scenes available on the Modules and Environment folders
	var mapinfo = loadModuleInfoFromFile("res://TextFiles/moduleinfo.txt")
	environmentTemplates.append_array(loadMapModuleTemplates(mapinfo))
	#mapModuleTemplates.append_array(loadMapModuleTemplates("res://MapGeneration/Modules/",mapinfo))
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
	if not generateObstacles and lastGeneratedPosition < currentPosition + minGeneratedTiles/2:
		lastGeneratedPosition = currentPosition + minGeneratedTiles/2
	generateObstacles = true

func addToQueue(array):
	obstacleQueue.append_array(array)

func updateModuleGroups(array):
	level_groups = array
	updatePossibleModules()

func updateModuleDifficulty(value: int):
	level_difficulty = value
	updatePossibleModules()

func clearOldModules():
	if len(mapModules) > 0:
		while mapModules[0].position.distance_to(Utils.gridRelativePosition(Vector2(),0,currentPosition,tilesize)) > minGeneratedTiles * tilesize and len(mapModules) > 1:
			clearOldestModule(mapModules)
	if len(environmentModules) > 0:
		while environmentModules[0].position.distance_to(Utils.gridRelativePosition(Vector2(),0,currentPosition,tilesize)) > minGeneratedTiles * tilesize and len(environmentModules) > 1:
			clearOldestModule(environmentModules)


func onUpdateCurrentPosition(pos):
	var new_position = position.distance_to(pos)/Vector2(tilesize/2,tilesize/-4).length()
	if new_position > lastGeneratedPosition + 10 and currentPosition <= lastGeneratedPosition + 10:
		Events.emit_signal("obstacles_ended")
	currentPosition = new_position
	updateCurrentModule(pos)



func updateCurrentModule(pos):
	currentModule = getCurrentModule(pos)
	if currentModule >= 0:
		z_index = -1 * mapModules[currentModule].z_index

		
func updatePossibleModules():
	validModules = []
	for module in mapModuleTemplates:
		if module["difficulty"] >= level_difficulty and module["difficulty"] >= 1 and (Utils.arrayHasItemsInCommon(module["group"],level_groups) >= 1 or len(level_groups) == 0):
			validModules.append(module)


#loads all scenes available on the Modules folders and returns them in a list
#will add more later
func loadMapModuleTemplates(modulesInfo = {}):
	var templates = []
	for filepath in modulesInfo.keys():
		var module = {"module" : load(filepath), "path" : filepath}
		module.merge(modulesInfo[filepath])
		templates.append(module)
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
	if len(possibleModules) == 0:
		print("Error: No possible modules!")
		return empty_module
	var index = randi() % len(possibleModules)
	var i = index
	var randomModule = possibleModules[i]
	while randomModule["difficulty"] <= difficulty or randomModule["difficulty"] < 1 or (Utils.arrayHasItemsInCommon(randomModule["group"],possibleGroups) < 1 and len(possibleGroups) > 0) or Utils.arrayHasItemsInCommon(randomModule["group"],[0]):
		i += 1
		if i >= len(possibleModules):
			i = 0
		if i == index:
			return empty_module
		randomModule = possibleModules[i]
	return randomModule
	


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
		randomModule = randomizeModule(validModules,difficulty,possibleGroups)
		while Utils.arrayHasItemsInCommon(randomModule["entry_lanes"],possibleLanes) < 2:
			randomModule = randomizeModule(validModules,difficulty,possibleGroups)

	possibleLanes = randomModule["exit_lanes"]
	var newMapModule
	if randomModule["module"] is PackedScene:
		newMapModule = randomModule["module"].instantiate()
	else:
		newMapModule = randomModule["module"].duplicate(DUPLICATE_SCRIPTS)

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
		if object.z_index + value < RenderingServer.CANVAS_ITEM_Z_MAX and object.z_index + value > RenderingServer.CANVAS_ITEM_Z_MIN:
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
