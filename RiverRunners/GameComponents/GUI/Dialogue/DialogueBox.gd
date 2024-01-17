extends Node2D

var sprite_paths = {"frog" : "res://Assets/Characters/frog/Frog.png", "beaver" : "res://Assets/Characters/beaver/Justin-Beaver.png", "crab" : "res://Assets/Characters/crab/Crab.png",
					"otter" : "res://Assets/Characters/otter/Otter.png", "salmon" : "res://Assets/Characters/salmon/Salmon-Baby.png", "shork" : "res://Assets/Characters/Shork/Shork.png",
					"frog_gray" : "res://Assets/Characters/frog/Frog-Gray.png", "beaver_gray" : "res://Assets/Characters/beaver/Justin-Beaver-Gray.png", "crab_gray" : "res://Assets/Characters/crab/Crab-Gray.png",
					"otter_gray" : "res://Assets/Characters/otter/Otter-Gray.png", "salmon_gray" : "res://Assets/Characters/salmon/Salmon-Gray.png", "shork_gray" : "res://Assets/Characters/Shork/Shork-Gray.png"}
var character_sprite
var textbox
var cutscene_sprite
var cutscene_previous_sprite

var cutscene_frames = {}

var textspeed = 0.02
var deltatime = 0.0
var current_text = ""
var char_count = 0

var dialogue_file = ""
var dialogues = []
var dialogue_index = 0

var current_frame = ""
var current_opacity = 0
var target_opacity = 0
var fade_time = 0.25

var holdtime = 0

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	character_sprite = get_node("Textbox/Character_sprite")
	cutscene_sprite = get_node("Control/Cutscene")
	cutscene_previous_sprite = get_node("Control/CutscenePrevious")
	textbox = get_node("Textbox/Text")

	visible = false

	Events.connect("pause_game", onPause)
	Events.connect("resume_game", onResume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible and not paused:
		updateDialogue(delta)
		updateCutscene(delta)
		if Input.is_action_just_pressed("confirm"):
			onContinue()
		handleSkip(delta)

func onContinue():
	if char_count == len(current_text):
		if dialogue_index < len(dialogues):
			newDialogue(dialogues[dialogue_index][0],dialogues[dialogue_index][1])
			newCutscene(dialogues[dialogue_index][2])
			fade_time = dialogues[dialogue_index][4]
			if dialogues[dialogue_index][3] != "":
				playSound(dialogues[dialogue_index][3])
			dialogue_index += 1
		else:
			disable()
			Events.emit_signal("on_dialog_end")
	else:
		char_count = len(current_text) - 1

func handleSkip(delta):
	if InputHandler.hasController():
		$InstructionsBox/Instructions.text = "Press X to continue - Hold to skip"
	else:
		$InstructionsBox/Instructions.text = "Press SPACEBAR to continue - Hold to skip"

	if Input.is_action_pressed("confirm"):
		holdtime += delta
		if holdtime > 0.1:
			if not $InstructionsBox/loader_circle.is_playing():
				$InstructionsBox/loader_circle.play("load")
		if holdtime > 1.0:
			skip()

	else:
		holdtime = 0
		$InstructionsBox/loader_circle.set_frame_and_progress(0, 0)

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
	cutscene_sprite.visible = true

func disable():
	visible = false
	deltatime = 0.0
	current_text = ""
	char_count = 0
	cutscene_sprite.visible = false

func skip():
	cutscene_sprite.modulate.a = 0
	current_opacity = 0
	target_opacity = 0
	cutscene_previous_sprite.modulate.a = 0
	for d in dialogues:
		if d[2] == "credits":
			Events.emit_signal("level_completed")
			Events.emit_signal("go_to_credits")
	disable()
	Events.emit_signal("on_dialog_end")

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
	var sound = ""
	var fade_time = 0.25
	while file.get_position() < file.get_length():
		if not line == "" and not line.begins_with("#") and not line.begins_with(">>>>>"):
			if line.begins_with("*Character*: "):
				character = line.replace("*Character*: ","")
			elif line.begins_with("*Cutscene*: "):
				cutscene_frame = line.replace("*Cutscene*: ","")
			elif line.begins_with("*Sound*: "):
				sound = line.replace("*Sound*: ","")
			elif line.begins_with("*FadeTime*: "):
				fade_time = line.replace("*FadeTime*: ","")
				if fade_time.is_valid_float():
					fade_time = fade_time.to_float()
				else:
					fade_time = 0.25
			elif line.begins_with("*Text*: "):
				text = line.replace("*Text*: ","")
			else:
				text += line
		elif line.begins_with(">>>>>"):
			dialogues.append([character,text,cutscene_frame,sound,fade_time])
			text = ""
			sound = ""
			fade_time = 0.25
		
		line = file.get_line()

	return dialogues
		

func newDialogue(character, text):
	if character == "none":
		get_node("Textbox/Box_sprite").visible = false
		get_node("ColorRect").visible = false
		character_sprite.visible = false
		textbox.visible = false

	elif character == "hidden":
		get_node("Textbox/Box_sprite").visible = true
		get_node("ColorRect").visible = false
		character_sprite.visible = false
		textbox.visible = true

		if text != "":
			current_text = text
			textbox.text = ""
			char_count = 0
			deltatime = 0.0
			if character in sprite_paths.keys():
				character_sprite.texture = load(sprite_paths[character])


	elif character != "":
		get_node("Textbox/Box_sprite").visible = true
		get_node("ColorRect").visible = true
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
		#cutscene_sprite.visible = false
		target_opacity = 0
		cutscene_previous_sprite.modulate.a = 0

	elif cutscene_file == "credits":
		Events.emit_signal("level_completed")
		Events.emit_signal("go_to_credits")

	elif cutscene_file != "":
		cutscene_sprite.visible = true
		cutscene_sprite.texture = load(cutscene_file)
		current_opacity = 0
		cutscene_sprite.modulate.a = current_opacity
		target_opacity = 1

func updateCutscene(delta):
	current_opacity = cutscene_sprite.modulate.a
	if target_opacity > current_opacity:
		current_opacity += delta/fade_time
	elif target_opacity < current_opacity:
		current_opacity -= delta/fade_time
	if current_opacity > 1:
		current_opacity = 1
	if current_opacity < 0:
		current_opacity = 0
	cutscene_sprite.modulate.a = current_opacity

	if current_opacity == 1:
		cutscene_previous_sprite.texture = cutscene_sprite.texture.duplicate()
		cutscene_previous_sprite.modulate.a = 1

func playSound(filepath):
	Utils.playSoundFile(self,filepath,"SFX",0)

func onPause():
	paused = true

func onResume():
	paused = false
