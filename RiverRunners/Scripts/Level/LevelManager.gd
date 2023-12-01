extends Node2D

@onready var player = $Player
@onready var map = $Map
@onready var dialogue_box = $Camera2D/DialogueBox


signal player_status(position, playerSpeed)

@export var tilesize = 380

var playerPosition = Vector2()
var playerSpeed = 1
var playerTargetSpeed = 1

@export var playerMaxSpeed = 10
@export var playerAcceleration = 0.1

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
			managePlayerSpeed()


		States.PAUSED:
			pass

		States.NO_OBSTACLES:
			managePlayerSpeed()
			map.disableObstacles()
				
		States.LEVEL_END:
			player.set_process(false)


func setLevelScript(level_id):
	level_script = load("res://Levels/LevelScripts.gd").new(self,level_id)
	add_child(level_script)

func managePlayerSpeed():
	if not playerSpeed == playerTargetSpeed:
		playerSpeed += playerAcceleration * (playerTargetSpeed - playerSpeed)
		Events.emit_signal("player_speed",playerSpeed)
	if abs(playerTargetSpeed - playerSpeed) < 0.01 and not playerTargetSpeed == playerSpeed:
		playerSpeed = playerTargetSpeed
		Events.emit_signal("player_speed",playerSpeed)

func onUpdatePlayerPosition(newposition):
	playerPosition = newposition

func onDialogEnd():
	current_state = States.RUNNING
	dialogue_box.disable()

func resume():
	current_state = States.RUNNING
	player.set_process(true)

func onPause():
	player.set_process(false)
	current_state = States.PAUSED

func onDie():
	player.set_process(false)
	Events.emit_signal("pause_game")


func isPaused():
	return current_state == States.PAUSED

func startDialogue(file: String):
	dialogue_box.setFile(file)
	Events.emit_signal("on_dialog_start")
	dialogue_box.enable()
	map.disableObstacles()
	current_state = States.DIALOG

func updateSpeed(speed):
	playerTargetSpeed = speed

func updateObstacleGroups(groups):
	map.updateModuleGroups(groups)

func updateObstacleState(value: bool):
	if value:
		map.enableObstacles()
	else:
		map.disableObstacles()

func onLevelEnd():
	Events.emit_signal("pause_game")
	current_state = States.LEVEL_END
