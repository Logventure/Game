extends Node2D

var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Area2D/AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.play("idle")
