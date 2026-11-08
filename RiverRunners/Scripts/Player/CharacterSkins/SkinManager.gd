extends Node

var settings : SkinManagerSettings = load("res://Scripts/Player/CharacterSkins/SkinManagerSettingsInstance.tres")

var skin_list = []

var character_skins = settings.get_character_skins()

var default_skins = settings.get_default_skins()

var active_skins = settings.get_active_skins()

# Called when the node enters the scene tree for the first time.
func _ready():
	list_available_skins()
	print("Available skins: ", skin_list)

func list_available_skins():
	skin_list = []
	for chara in character_skins.keys():
		skin_list.append_array(character_skins[chara].keys())

func get_active_skin_resource(character: String):
	if character in active_skins.keys() and character in default_skins.keys():
		if character in character_skins.keys():
			if character_skins[character] is Dictionary:
				if character_skins[character].keys().size() > 0:
					return character_skins[character].get(active_skins[character], default_skins[character])

func set_active_skin(character: String, skin_id: String):
	if skin_id in skin_list and skin_id.contains(character) and character in active_skins.keys():
		active_skins[character] = skin_id
