extends Control
#receber sinal do speed do player e com base nele dar scale ao UI para encaixar na janela do jogo
signal health_changed
@onready var heartsContainer = $HeartsContainer
var maxHealth = 3
var currentHealth = maxHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("damage_taken", onDamageTaken)

	heartsContainer.setMaxHearts(maxHealth)
	heartsContainer.updateHearts(currentHealth)
	Events.connect("health_changed", heartsContainer.updateHearts)	


func onDamageTaken(damage):
	if currentHealth <= 0:
		currentHealth = maxHealth #when dies send signal to levelManager, who receives the signal and sends it to a onDie function to change the state to PAUSED. After that, level manager send signal to UImanager back to pop up gameover scene
	else: 
		currentHealth -= damage
		Events.emit_signal("health_changed", currentHealth)
