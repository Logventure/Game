extends Node2D

var sprite_paths = {"frog" : "res://Assets/Characters/Frog.png", "beaver" : "res://Assets/Characters/Justin-Beaver.png", "crab" : "res://Assets/Characters/Crab.png",
					"otter" : "res://Assets/Characters/Otter.png", "salmon" : "res://Assets/Characters/Salmon.png"}
var character_sprite
var textbox

var textspeed = 0.02
var deltatime = 0.0
var current_text = ""
var char_count = 0

var dialogue_file = "res://TextFiles/Dialogues/testdialogue.txt"
var dialogues = []
var dialogue_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	character_sprite = get_node("Character_sprite")
	textbox = get_node("Text")

	visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateDialogue(delta)
	if Input.is_action_just_pressed("print"):
		onContinue()

func onContinue():
	if char_count == len(current_text):
		if dialogue_index < len(dialogues):
			newDialogue(dialogues[dialogue_index][0],dialogues[dialogue_index][1])
			dialogue_index += 1
		else:
			disable()
	else:
		char_count = len(current_text) - 1

func enable():
	visible = true
	textbox.text = ""
	if(dialogue_file != ""):
		dialogues = loadChat(dialogue_file)
	dialogue_index = 0
	onContinue()

func disable():
	visible = false
	deltatime = 0.0
	current_text = ""
	char_count = 0

func setFile(filepath: String):
	if FileAccess.file_exists(filepath):
		dialogue_file = filepath

func loadChat(filepath: String):
	var file = FileAccess.open(filepath,FileAccess.READ)
	var line = file.get_line()
	var dialogues = []
	var character = ""
	var text = ""
	while file.get_position() < file.get_length():
		
		if not line == "" and not line.begins_with("#") and not line.begins_with(">>>>>"):
			if line.begins_with("*Character*: "):
				character = line.replace("*Character*: ","")
			elif line.begins_with("*Text*: "):
				text = line.replace("*Text*: ","")
			else:
				text += line
		elif line.begins_with(">>>>>"):
			dialogues.append([character,text])
			text = ""
		
		line = file.get_line()

	return dialogues
		

func newDialogue(character, text):
	current_text = text
	textbox.text = ""
	char_count = 0
	deltatime = 0.0
	if character in sprite_paths.keys():
		character_sprite.texture = load(sprite_paths[character])

func updateDialogue(delta):
	deltatime += delta
	if deltatime > textspeed:
		if char_count < len(current_text):
			char_count += 1
			textbox.text = current_text.substr(0,char_count)
		deltatime = 0.0

