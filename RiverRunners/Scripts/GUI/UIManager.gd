extends Control
#receber sinal do speed do player e com base nele dar scale ao UI para encaixar na janela do jogo
signal health_changed
@onready var healthContainer = $HealthContainer
@onready var pauseScene = $PauseMenu
@onready var gameoverScene = $GameoverMenu
@onready var levelcompleteScene = $LevelCompleteMenu
@onready var score = $Score
@onready var endlessgameoverScene = $EndlessGameoverMenu
@onready var progressBar = $ProgressBar
var maxHealth = 3
var currentHealth = maxHealth
var isInfinite

var character_availability = {"beaver" : true, "frog" : true, "salmon" : true, "crab" : true, "otter" : true}

enum States{RUNNING, PAUSED, GAMEOVER, COMPLETED, OPTIONS}
var current_state = States.RUNNING

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("damage_taken", onDamageTaken)

	healthContainer.setMaxHealth(maxHealth)
	healthContainer.updateHealth(currentHealth)
	Events.connect("health_changed", healthContainer.updateHealth)	

	Events.connect("pause_game", pause)

	Events.connect("player_died", gameover)

	Events.connect("resume_game", onResume)

	Events.connect("level_completed", completed)

	Events.connect("go_to_options", onGoToOptions)
	Events.connect("go_to_previous_screen", backFromOptions)

	pauseScene.visible = false
	gameoverScene.visible = false
	levelcompleteScene.visible = false

func _process(delta):
	match current_state:
		States.RUNNING:
			cooldowns()
		States.PAUSED:
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $PauseMenu/Panel/VBoxContainer/ResumeButton.visible == true:
					$PauseMenu/Panel/VBoxContainer/ResumeButton.grab_focus()
			
		States.GAMEOVER:
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $GameoverMenu/Panel/VBoxContainer/RetryButton.visible == true:
					$GameoverMenu/Panel/VBoxContainer/RetryButton.grab_focus()
			
		States.OPTIONS:
			pass
		States.COMPLETED:
			if InputHandler.hasController() and get_viewport().gui_get_focus_owner() == null:
				if $LevelCompleteMenu/Panel/VBoxContainer/NextLevelButton.visible == true:
					$LevelCompleteMenu/Panel/VBoxContainer/NextLevelButton.grab_focus()
			

func onDamageTaken(damage):
	if currentHealth <= 1:
		#currentHealth = maxHealth #when dies send signal to levelManager, who receives the signal and sends it to a onDie function to change the state to PAUSED. After that, level manager send signal to UImanager back to pop up gameover scene
		#healthContainer.setMaxHealth(maxHealth)
		Events.emit_signal("player_died")
	currentHealth -= damage
	Events.emit_signal("health_changed", currentHealth)

func pause():
	gameoverScene.visible = false
	levelcompleteScene.visible = false

	pauseScene.visible = true
	pauseScene.resetFocusedButton()

	score.stop_counting()
	current_state = States.PAUSED


func gameover():
	pauseScene.visible = false
	levelcompleteScene.visible = false

	print("is infinite:", isInfinite)

	if isInfinite:
		gameoverScene.visible = false
		gameoverScene.resetFocusedButton()

		#enviar sinal com o highest score obtido e verificar se o score e maior que o highestscore
		score.stop_counting()
		score.checkHighestScore()
		endlessgameoverScene.visible = true
		endlessgameoverScene.highest_score(score.get_points())
	else: 		
		endlessgameoverScene.visible = false

		gameoverScene.visible = true
		gameoverScene.resetFocusedButton()

	current_state = States.GAMEOVER


func completed():
	pauseScene.visible = false
	gameoverScene.visible = false

	levelcompleteScene.visible = true
	levelcompleteScene.resetFocusedButton()

	current_state = States.COMPLETED


func onGoToOptions():
	current_state = States.OPTIONS
	pauseScene.visible = false

func backFromOptions():
	current_state = States.PAUSED
	pauseScene.visible = true

func onResume():
	current_state = States.RUNNING
	pauseScene.visible = false
	gameoverScene.visible = false
	levelcompleteScene.visible = false
	score.counting()

func updateProgressBar(progress):
	progressBar.updateProgressBar(progress)

func updateCharacters(char_list):
	character_availability["beaver"] = char_list.has("beaver")
	character_availability["frog"] = char_list.has("frog")
	character_availability["salmon"] = char_list.has("salmon")
	character_availability["crab"] = char_list.has("crab")
	character_availability["otter"] = char_list.has("otter")

func isCharacterAvailable(character):
	if character_availability.has(character):
		return character_availability[character]

func cooldowns():
	$SalmonCooldown.visible = true if isCharacterAvailable("salmon") else false
	$CrabCooldown.visible = true if isCharacterAvailable("crab") else false
	$OtterCooldown.visible = true if isCharacterAvailable("otter") else false
