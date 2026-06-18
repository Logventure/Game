extends Node

const achievement_version = 0

var achievements: Dictionary = {
    "ACH_WIN_ONE_GAME": false,
    "ACH_WIN_100_GAMES": false,
    "ACH_TRAVEL_FAR_ACCUM": false,
	"ACH_TRAVEL_FAR_SINGLE": false,
	"NEW_ACHIEVEMENT_0_4": false
    }
var statistics: Dictionary = {
    "NumGames": 0,
    "NumWins": 0,
    "NumLosses": 0,
    "FeetTraveled": 0,
    "AverageSpeed": 0,
    "Unused2": 0,
    "MaxFeetTraveled": 0
    }

func _init():
	var response : Dictionary = Steam.steamInitEx(480)
	print(response)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_steam_stats() -> void:
	for this_stat in statistics.keys():
		var stat_value: int = Steam.getStatInt(this_stat)
		print("Retrieved %s stat: %s" % this_stat, stat_value)

		# Store the value in our dictionary
		statistics[this_stat] = stat_value
	print("Steam statistics loaded")

# Process achievements
func load_steam_achievements() -> void:
	for this_achievement in achievements.keys():
		var steam_achievement: Dictionary = Steam.getAchievement(this_achievement)

        # Does the achievement actually exist in the Steamworks back-end?
		if not steam_achievement['ret']:
			print("Steam does not have this achievement, ignoring it")
			continue

		achievements[this_achievement] = steam_achievement['achieved']
	print("Steam achievements loaded")

func set_achievement(this_achievement: String) -> void:
	if not achievements.has(this_achievement):
		print("This achievement does not exist locally: %s" % this_achievement)
		return
	achievements[this_achievement] = true

	if not Steam.setAchievement(this_achievement):
		print("Failed to set achievement: %s" % this_achievement)
		return

	print("Set achievement: %s" % this_achievement)
	store_steam_data()

func set_statistic(this_stat: String, new_value: int = 1) -> void:
	if not statistics.has(this_stat):
		print("This statistic does not exist locally: %s" % this_stat)
		return
    # Set our local version
	statistics[this_stat] += new_value

    # Set Steam's version
	if not Steam.setStatInt(this_stat, new_value):
		print("Failed to set stat %s to: %s" % [this_stat, new_value])
		return

	print("Set statistics %s succesfully: %s" % [this_stat, new_value])
	store_steam_data()

func store_steam_data() -> void:
	if not Steam.storeStats():
		print("Failed to store data on Steam, should be stored locally")
		return
	print("Data successfully sent to Steam")