extends Node2D

@onready var player = $Player
@onready var map = $Map
@onready var dialogue_box = $Camera2D/DialogueBox
@onready var level_ui = $Camera2D/LevelUI
@onready var score = $Camera2D/LevelUI/Score
@onready var progress_bar = $Camera2D/LevelUI/ProgressBar
@onready var health_bar = $Camera2D/LevelUI/HealthContainer

signal player_status(position, playerSpeed)

@export var tilesize = 380

var playerPosition = Vector2()
var playerSpeed = 1
var playerTargetSpeed = 1

@export var playerMaxSpeed = 10
@export var playerAcceleration = 0.5

var relax_mode = false

enum States {DIALOG,RUNNING,PAUSED,NO_OBSTACLES,LEVEL_END}

var current_state = States.NO_OBSTACLES

var level_script

# Called when the node enters the scene tree for the first time.
func _ready():
	#connects to player position signal
	Events.connect("player_position", onUpdatePlayerPosition)

	Events.connect("on_dialog_end", onDialogEnd)

	Events.connect("resume_game", resume)

	Events.connect("pause_game", onPause)

	Events.connect("player_died", onDie)

	Events.emit_signal("player_speed",playerSpeed)

	if isEndless():
		score.visible = true
		progress_bar.visible = false
		level_ui.isInfinite = true
	else:
		score.visible = false
		progress_bar.visible = true
		level_ui.isInfinite = false

	level_ui.setRelaxMode(relax_mode)
	
	
	#level_script = load("res://Levels/LevelTestScript.gd").new()
	#add_child(level_script)
	#level_script.setManager(self)
	#setLevelScript("level_1","res://TextFiles/Levels/level_scripts.txt")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	match current_state:
		States.DIALOG:
			pass

		States.RUNNING:
			managePlayerSpeed(delta)


		States.PAUSED:
			pass

		States.NO_OBSTACLES:
			managePlayerSpeed(delta)
			map.disableObstacles()
				
		States.LEVEL_END:
			player.set_process(false)

	updateProgressBar()

func setLevelScript(level_id):
	level_script = load("res://Scripts/Level/LevelScripts.gd").new(self,level_id)
	add_child(level_script)

func managePlayerSpeed(delta):
	if playerSpeed > playerTargetSpeed:
		playerSpeed -= playerAcceleration * delta
		if playerSpeed < playerTargetSpeed:
			playerSpeed = playerTargetSpeed
		Events.emit_signal("player_speed",playerSpeed)

	elif playerSpeed < playerTargetSpeed:
		playerSpeed += playerAcceleration * delta
		if playerSpeed > playerTargetSpeed:
			playerSpeed = playerTargetSpeed
		Events.emit_signal("player_speed",playerSpeed)

func onUpdatePlayerPosition(newposition):
	playerPosition = newposition

func onDialogEnd():
	current_state = States.RUNNING
	dialogue_box.disable()
	if isEndless():
		score.counting()

func resume():
	current_state = States.RUNNING
	player.set_process(true)
	if isEndless():
		score.counting()

func onPause():
	player.set_process(false)
	current_state = States.PAUSED
	if isEndless():
		score.stop_counting()

func onDie():
	if not relax_mode:
		player.set_process(false)
		Events.emit_signal("pause_game")

func isPaused():
	return current_state == States.PAUSED

func isEndless():
	if level_script:
		return level_script.isEndless()
	return true

func getProgress():
	if level_script:
		return level_script.getProgress()
	return 0

func updateProgressBar():
	level_ui.updateProgressBar(getProgress())

func onStartDialogue(file: String, wait_for_obstacle_end: bool):
	if wait_for_obstacle_end:
		Events.connect("obstacles_ended",startDialogue.bind(file))
	else:
		startDialogue(file)

func startDialogue(file: String):
	dialogue_box.setFile(file)
	Events.emit_signal("on_dialog_start")
	dialogue_box.enable()
	map.disableObstacles()
	current_state = States.DIALOG
	if Events.is_connected("obstacles_ended",startDialogue):
		Events.disconnect("obstacles_ended",startDialogue)

func updateSpeed(speed):
	playerTargetSpeed = speed
	updateObstacleDifficulty(speed - 1)

func updateObstacleGroups(groups):
	map.updateModuleGroups(groups)

func updateObstacleDifficulty(difficulty):
	map.updateModuleDifficulty(difficulty)

func updateObstacleState(value: bool):
	if value:
		map.enableObstacles()
		current_state = States.RUNNING
	else:
		map.disableObstacles()
		current_state = States.NO_OBSTACLES

func setCharacters(character_list):
	player.updateCharacters(character_list)
	level_ui.updateCharacters(character_list)

func onLevelEnd(wait_for_obstacle_end: bool):
	if wait_for_obstacle_end:
		Events.connect("obstacles_ended",finishLevel)
	else:
		finishLevel()

func finishLevel():
	Events.emit_signal("pause_game")
	Events.emit_signal("level_completed")
	current_state = States.LEVEL_END
	if Events.is_connected("obstacles_ended",finishLevel):
		Events.disconnect("obstacles_ended",finishLevel)

func setRelaxMode(value: bool):
	relax_mode = value
	if level_ui != null:
		level_ui.setRelaxMode(relax_mode)
