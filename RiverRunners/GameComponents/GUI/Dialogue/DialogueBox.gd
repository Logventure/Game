extends Node2D

var sprite_paths = {"frog" : "res://Assets/Characters/Frog.png", "beaver" : "res://Assets/Characters/Justin-Beaver.png"}
var character_sprite
var textbox

var textspeed = 0.02
var deltatime = 0.0
var current_text = ""
var char_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	character_sprite = get_node("Character_sprite")
	textbox = get_node("Text")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("text"):
		newDialogue("frog","Frog is talking... AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH")
	
	updateDialogue(delta)


func newDialogue(character, text):
	current_text = text
	textbox.text = ""
	if character in sprite_paths.keys():
		character_sprite.texture = load(sprite_paths[character])

func updateDialogue(delta):
	deltatime += delta
	if deltatime > textspeed:
		if char_count < len(current_text):
			char_count += 1
			textbox.text = current_text.substr(0,char_count)
		deltatime = 0.0

