extends Node

const STEAM_APP_ID = 3835560

const achievement_version = 0

var is_initialized : bool = false

var achievements: Dictionary = {
	"level1_complete": false,
	"level2_complete": false,
	"level3_complete": false,
	"level4_complete": false,
	"level5_complete": false,
	"level6_complete": false,
	"infinite_reach_1000pts": false,
	"poke_beaver_20": false
	}
var statistics: Dictionary = {
	"infinitemode_highscore": 0,
	"level_completion_progress": 0,
	"beaver_total_poke": 0
	}

var current_handle: int = 0 
var leaderboard_handles: Dictionary = {
	"infinite_highscore": 0
	}

func _init():
	var response : Dictionary = Steam.steamInitEx(STEAM_APP_ID)
	is_initialized = response["status"] == 0
	if is_initialized:
		Steam.leaderboard_find_result.connect(_on_leaderboard_find_result)
		Steam.leaderboard_score_uploaded.connect(_on_leaderboard_score_uploaded)
		load_steam_stats()
		load_steam_achievements()
		load_steam_infinite_leaderboard()
		print("beaver poke ", get_statistic("beaver_total_poke"))


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_steam_stats() -> void:
	for this_stat in statistics.keys():
		var stat_value: int = Steam.getStatInt(this_stat)
		#print("Retrieved %s stat: %s" % this_stat, stat_value)

		# Store the value in our dictionary
		statistics[this_stat] = stat_value
	print("Steam statistics loaded")

# Process achievements
func load_steam_achievements() -> void:
	for this_achievement in achievements.keys():
		var steam_achievement: Dictionary = Steam.getAchievement(this_achievement)

		# Does the achievement actually exist in the Steamworks back-end?
		if not 'ret' in steam_achievement.keys():
			print("Steam does not have this achievement, ignoring it")
			continue

		achievements[this_achievement] = steam_achievement['achieved']
	print("Steam achievements loaded")

func load_steam_infinite_leaderboard() -> void:
	Steam.findLeaderboard("infinite_highscore")

func set_achievement(this_achievement: String) -> void:
	if is_initialized:
		if not achievements.has(this_achievement):
			#print("This achievement does not exist locally: %s" % this_achievement)
			return
		achievements[this_achievement] = true

		if not Steam.setAchievement(this_achievement):
			#print("Failed to set achievement: %s" % this_achievement)
			return

		#print("Set achievement: %s" % this_achievement)
		store_steam_data()

func set_statistic(this_stat: String, new_value: int = 1) -> void:
	if is_initialized:
		if not statistics.has(this_stat):
			#print("This statistic does not exist locally: %s" % this_stat)
			return
		# Set our local version
		statistics[this_stat] = new_value

		# Set Steam's version
		if not Steam.setStatInt(this_stat, new_value):
			#print("Failed to set stat %s to: %s" % [this_stat, new_value])
			return

		#print("Set statistics %s succesfully: %s" % [this_stat, new_value])
		store_steam_data()

func add_to_statistic(this_stat: String, new_value: int = 1) -> void:
	if is_initialized:
		if not statistics.has(this_stat):
			#print("This statistic does not exist locally: %s" % this_stat)
			return
		# Set our local version
		statistics[this_stat] += new_value

		# Set Steam's version
		if not Steam.setStatInt(this_stat, statistics[this_stat]):
			#print("Failed to set stat %s to: %s" % [this_stat, new_value])
			return

		#print("Set statistics %s succesfully: %s" % [this_stat, new_value])
		store_steam_data()

func store_steam_data() -> void:
	if not Steam.storeStats():
		print("Failed to store data on Steam, should be stored locally")
		return
	print("Data successfully sent to Steam")

func get_statistic(this_stat: String) -> int:
	if statistics[this_stat]:
		return statistics[this_stat]
	return 0

func upload_highscore(score: int, leaderboard_handle: int):
	if is_initialized:
		print("Upload this score ", score, " to this leaderboard ", leaderboard_handle)
		Steam.uploadLeaderboardScore( score, true, [], leaderboard_handle)

func upload_infinite_highscore(score: int):
	upload_highscore(score, leaderboard_handles["infinite_highscore"])

func _on_leaderboard_find_result(new_handle: int, was_found: int) -> void:
	if was_found != 1:
		print("Leaderboard handle could not be found")
		return

	current_handle = new_handle

	var api_name: String = Steam.getLeaderboardName(new_handle)
	print("Leaderboard: ", api_name)
	leaderboard_handles[api_name] = current_handle

	#print("Leaderboard %s handle found: %s" % [api_name, current_handle])

func _on_leaderboard_score_uploaded(success: int, this_handle: int, this_score: Dictionary) -> void:
	if success == 0:
		print("Failed to upload score to leaderboard")
		return

	print("Successfully uploaded score to leaderboard")
