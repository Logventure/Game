extends Control
#receber sinal do speed do player e com base nele dar scale ao UI para encaixar na janela do jogo
signal health_changed
@onready var healthContainer = $HealthContainer
@onready var pauseScene = $PauseMenu
@onready var gameoverScene = $GameoverMenu
var maxHealth = 3
var currentHealth = maxHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("damage_taken", onDamageTaken)

	healthContainer.setMaxHealth(maxHealth)
	healthContainer.updateHealth(currentHealth)
	Events.connect("health_changed", healthContainer.updateHealth)	

	Events.connect("pause_game", pause)

	Events.connect("player_died", gameover)



func onDamageTaken(damage):
	if currentHealth <= 1:
		#currentHealth = maxHealth #when dies send signal to levelManager, who receives the signal and sends it to a onDie function to change the state to PAUSED. After that, level manager send signal to UImanager back to pop up gameover scene
		#healthContainer.setMaxHealth(maxHealth)
		Events.emit_signal("player_died")
	currentHealth -= damage
	Events.emit_signal("health_changed", currentHealth)

func pause():
	pauseScene.visible = true

func gameover():
	gameoverScene.visible = true
