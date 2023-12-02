extends Control
#receber sinal do speed do player e com base nele dar scale ao UI para encaixar na janela do jogo
signal health_changed
@onready var healthContainer = $HealthContainer
@onready var pauseScene = $PauseMenu
@onready var gameoverScene = $GameoverMenu
var maxHealth = 3
var currentHealth = maxHealth

enum States{RUNNING, PAUSED, GAMEOVER, OPTIONS}
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

	Events.connect("go_to_options", onGoToOptions)
	Events.connect("go_to_previous_screen", backFromOptions)

	pauseScene.visible = false
	gameoverScene.visible = false

func _process(delta):
	match current_state:
		States.RUNNING:
			pass
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


func onDamageTaken(damage):
	if currentHealth <= 1:
		#currentHealth = maxHealth #when dies send signal to levelManager, who receives the signal and sends it to a onDie function to change the state to PAUSED. After that, level manager send signal to UImanager back to pop up gameover scene
		#healthContainer.setMaxHealth(maxHealth)
		Events.emit_signal("player_died")
	currentHealth -= damage
	Events.emit_signal("health_changed", currentHealth)

func pause():
	pauseScene.visible = true
	pauseScene.resetFocusedButton()
	current_state = States.PAUSED

func gameover():
	gameoverScene.visible = true
	gameoverScene.resetFocusedButton()
	current_state = States.GAMEOVER

func onGoToOptions():
	current_state = States.OPTIONS
	pauseScene.visible = false

func backFromOptions():
	current_state = States.PAUSED
	pauseScene.visible = true

func onResume():
	current_state = States.RUNNING