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
		currentHealth = maxHealth #dies
	else: 
		currentHealth -= damage
		Events.emit_signal("health_changed", currentHealth)
