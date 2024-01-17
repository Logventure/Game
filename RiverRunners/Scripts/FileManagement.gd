const SAVE_PATH = "user://settings.cfg"
const SAVE_PATH_SCORE = "user://score.cfg"
const SAVE_PATH_LEVELS = "user://levels.cfg"
const SAVE_PATH_DIFFICULTY = "user://difficulty.cfg"
const SAVE_PATH_SOUND = "user://sound.cfg"
const SAVE_PATH_MASTER = "user://master.cfg"
const SAVE_PATH_MUSIC = "user://music.cfg"
const SAVE_PATH_AMBIENCE = "user://ambience.cfg"


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
					if InputMap.has_action(key):
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

static func saveHighestScore(score: int):
	var config = ConfigFile.new()

	config.set_value("score", "highestScore", score)

	config.save(SAVE_PATH_SCORE)

static func loadLevels():
	var config = ConfigFile.new()

	var valid = config.load(SAVE_PATH_LEVELS) == OK

	if valid:
		valid = config.has_section("levels")
	
	if valid:
		return config.get_value("levels", "level")

static func saveLevels(level: int):
	var config = ConfigFile.new()

	config.set_value("levels", "level", level)

	config.save(SAVE_PATH_LEVELS)

static func loadDifficulty():
	var config = ConfigFile.new()

	var valid = config.load(SAVE_PATH_DIFFICULTY) == OK

	if valid:
		valid = config.has_section("difficulty")
	
	if valid:
		return config.get_value("difficulty", "mode")

static func saveDifficulty(mode: int):
	var config = ConfigFile.new()

	config.set_value("difficulty", "mode", mode)

	config.save(SAVE_PATH_DIFFICULTY)

static func loadSounds():
	var array = {}
	array[0] = loadMaster()
	array[1] = loadSound()
	array[2] = loadMusic()
	array[3] = loadAmbience()

	return array

static func loadMaster():
	var config = ConfigFile.new()
	var sound
	var valid = config.load(SAVE_PATH_MASTER) == OK

	if valid:
		valid = config.has_section("sound")
	
	if valid:
		sound = config.get_value("sound", "Master")
		
		return sound

static func saveMaster(value):
	var config = ConfigFile.new()

	config.set_value("sound", "Master", value)

	config.save(SAVE_PATH_MASTER)

static func loadSound():
	var config = ConfigFile.new()
	var sound
	var valid = config.load(SAVE_PATH_SOUND) == OK

	if valid:
		valid = config.has_section("sound")
	
	if valid:
		sound = config.get_value("sound", "Sound")
		
		return sound

static func saveSound(value):
	var config = ConfigFile.new()

	config.set_value("sound", "Sound", value)

	config.save(SAVE_PATH_SOUND)

static func loadMusic():
	var config = ConfigFile.new()
	var sound
	var valid = config.load(SAVE_PATH_MUSIC) == OK

	if valid:
		valid = config.has_section("sound")
	
	if valid:
		sound = config.get_value("sound", "Music")
		
		return sound

static func saveMusic(value):
	var config = ConfigFile.new()

	config.set_value("sound", "Music", value)

	config.save(SAVE_PATH_MUSIC)

static func loadAmbience():
	var config = ConfigFile.new()
	var sound
	var valid = config.load(SAVE_PATH_AMBIENCE) == OK

	if valid:
		valid = config.has_section("sound")
	
	if valid:
		sound = config.get_value("sound", "Ambience")
		
		return sound

static func saveAmbience(value):
	var config = ConfigFile.new()

	config.set_value("sound", "Ambience", value)

	config.save(SAVE_PATH_AMBIENCE)
