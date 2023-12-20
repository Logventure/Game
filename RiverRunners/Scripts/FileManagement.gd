const SAVE_PATH = "user://settings.cfg"
const SAVE_PATH_SCORE = "user://score.cfg"

static func loadConfig():
	var config = ConfigFile.new()

	var valid = config.load(SAVE_PATH) == OK

	if valid:
		valid = config.has_section("input")

	if !valid:
		saveConfig()
	

	for section in config.get_sections():
		match(section):
			"input":
				for key in config.get_section_keys(section):
					InputMap.action_erase_events(key)
					
					var events = config.get_value(section, key)
					for event in events:
						InputMap.action_add_event(key, event)

static func saveConfig():
	var config = ConfigFile.new()

	for action in InputMap.get_actions():
		config.set_value("input", action, InputMap.action_get_events(action))

	config.save(SAVE_PATH)

static func loadHighestScore():
	var config = ConfigFile.new()

	var valid = config.load(SAVE_PATH_SCORE) == OK

	if valid:
		valid = config.has_section("score")
	
	if valid:
		return config.get_value("score", "highestScore")

static func saveHighestScore(score):
	var config = ConfigFile.new()

	config.set_value("score", "highestScore", score)

	config.save(SAVE_PATH_SCORE)