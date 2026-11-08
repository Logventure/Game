extends Resource

class_name CharacterSkin

@export_category("General")
@export var skin_id: String
@export var skin_name: String
@export var skin_icon: Texture2D
@export_category("Dialogue")
@export var dialogue_emotes: Dictionary #string (character_emote): Texture2D
@export_category("Gameplay")
@export var animations: SpriteFrames

func get_emote(id:String):
	return dialogue_emotes.get(id,null)

func get_animations():
	return animations
