extends Node2D

var sprite_paths = {"frog" : "res://Assets/Characters/frog/Frog.png", "beaver" : "res://Assets/Characters/beaver/Justin-Beaver.png", "crab" : "res://Assets/Characters/crab/Crab.png",
					"otter" : "res://Assets/Characters/otter/Otter.png", "salmon" : "res://Assets/Characters/salmon/Salmon-Baby.png"}
var character_sprite
var textbox
var cutscene_sprite

var cutscene_frames = {}

var textspeed = 0.02
var deltatime = 0.0
var current_text = ""
var char_count = 0

var dialogue_file = ""
var dialogues = []
var dialogue_index = 0

var current_frame = ""

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	character_sprite = get_node("Textbox/Character_sprite")
	cutscene_sprite = get_node("Control/Cutscene")
	textbox = get_node("Textbox/Text")

	visible = false

	Events.connect("pause_game", onPause)
	Events.connect("resume_game", onResume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible and not paused:
		updateDialogue(delta)
		if Input.is_action_just_pressed("confirm"):
			onContinue()

func onContinue():
	if char_count == len(current_text):
		if dialogue_index < len(dialogues):
			newDialogue(dialogues[dialogue_index][0],dialogues[dialogue_index][1])
			newCutscene(dialogues[dialogue_index][2])
			dialogue_index += 1
		else:
			disable()
			Events.emit_signal("on_dialog_end")
	else:
		char_count = len(current_text) - 1

	

func enable():
	textbox.text = ""
	current_text = ""
	char_count = 0
	deltatime = 0.0
	if(dialogue_file != ""):
		dialogues = loadChat(dialogue_file)
	dialogue_index = 0
	onContinue()
	visible = true

func disable():
	visible = false
	deltatime = 0.0
	current_text = ""
	char_count = 0
	cutscene_sprite.visible = false

func setFile(filepath: String):
	if FileAccess.file_exists(filepath):
		dialogue_file = filepath

func loadChat(filepath: String):
	var file = FileAccess.open(filepath,FileAccess.READ)
	var line = file.get_line()
	var dialogues = []
	var character = ""
	var text = ""
	var cutscene_frame = ""
	while file.get_position() < file.get_length():
		if not line == "" and not line.begins_with("#") and not line.begins_with(">>>>>"):
			if line.begins_with("*Character*: "):
				character = line.replace("*Character*: ","")
			elif line.begins_with("*Cutscene*: "):
				cutscene_frame = line.replace("*Cutscene*: ","")
			elif line.begins_with("*Text*: "):
				text = line.replace("*Text*: ","")
			else:
				text += line
		elif line.begins_with(">>>>>"):
			dialogues.append([character,text,cutscene_frame])
			text = ""
		
		line = file.get_line()

	return dialogues
		

func newDialogue(character, text):
	if character == "none":
		get_node("Textbox/Box_sprite").visible = false
		character_sprite.visible = false
		textbox.visible = false

	elif character != "":
		get_node("Textbox/Box_sprite").visible = true
		character_sprite.visible = true
		textbox.visible = true

		if text != "":
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

func newCutscene(cutscene_file):
	if cutscene_file == "none":
		cutscene_sprite.visible = false
	elif cutscene_file != "":
		cutscene_sprite.texture = load(cutscene_file)
		cutscene_sprite.visible = true

func onPause():
	paused = true

func onResume():
	paused = false
