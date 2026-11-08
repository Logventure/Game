extends Resource

class_name SkinManagerSettings

@export var character_skins = {"log": {},
							   "beaver": {},
							   "frog": {},
							   "salmon": {},
							   "crab": {},
							   "otter": {},
							   "shork": {}
							   }

@export var default_skins = {"log": "log_default",
							   "beaver": "beaver_default",
							   "frog": "frog_default",
							   "salmon": "salmon_default",
							   "crab": "crab_default",
							   "otter": "otter_default",
							   "shork": "shork_default"
							   }

@export var active_skins = {"log": "log_default",
							   "beaver": "beaver_default",
							   "frog": "frog_default",
							   "salmon": "salmon_default",
							   "crab": "crab_default",
							   "otter": "otter_default",
							   "shork": "shork_default"
							   }

func get_character_skins():
	return character_skins.duplicate()

func get_default_skins():
	return default_skins.duplicate()

func get_active_skins():
	return active_skins.duplicate()