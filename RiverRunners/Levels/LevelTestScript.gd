extends Node

#About the events
#
#All must have a string id (the dicionary entry's key), Time offset (in seconds), Type (see listed below),
# Prerequisites (array with the prerequisite events' ids, [] if there are no prerequisites)
#
#Event types
#
#Dialogue : starts a character dialogue, must have a File (text file that contains the dialogue)
#
#setValues : changes level parameters such as GenerateObstacles (true/false), Speed (int), ...
#
#
#
#
#
#
#
#

enum eventTypes {DIALOGUE, SETVALUES, CUTSCENE, ENDLEVEL}

var level_events = {"setup"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : []},
					"chat1"         :    {"Time offset" : 1,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/anotherdialogue.txt"},
					"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
					"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
					"speedUp2"      :    {"Time offset" : 10,    "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
					"disableObs"    :    {"Time offset" : 5,    "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
					"endCutscene"   :    {"Time offset" : 5,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.CUTSCENE,    "File": "whatever"},
					"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["endCutscene"],   "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/enddialogue.txt"},
					"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
}


#don't change anything below this line

var level_manager = null

enum eventStatus {NOT_DONE, IN_PROGRESS, FINISHED}

var level_events_status = {}
var ready_to_process = {}

func setManager(manager: Node):
	level_manager = manager

func _ready():
	for id in level_events.keys():
		level_events_status[id] = eventStatus.NOT_DONE
		if level_events[id].has("Prerequesites"):
			if level_events[id]["Prerequesites"] == []:
				ready_to_process[id] = true
			else:
				ready_to_process[id] = false

	Events.connect("on_dialog_end", onDialogueEnd)

	print("Dicts: ", ready_to_process, ", ", level_events_status)

func _process(delta):
	if Input.is_action_just_pressed("controller_throw"):
		onDialogueEnd()
	
	processEvents()

	print("Level Script: Manager -> ", level_manager)


func processEvents():
	for id in level_events.keys():
		if level_events_status[id] == eventStatus.NOT_DONE and ready_to_process[id] == true:
			if level_events[id]["Time offset"] == 0:
				executeEvent(id, level_events[id])
			else:
				scheduleEvent(id, level_events[id])

func executeEvent(id : String, details: Dictionary):
	if level_manager != null and level_events_status[id] == eventStatus.NOT_DONE:
		match details["Type"]:
			eventTypes.DIALOGUE:
				print("Dialogue event: ", id, details)
				if details.has("File"):
					level_manager.startDialogue(details["File"])
					level_events_status[id] = eventStatus.IN_PROGRESS
				else:
					level_events_status[id] = eventStatus.FINISHED
			eventTypes.SETVALUES:
				if details.has("Speed"):
					level_manager.updateSpeed(details["Speed"])
				if details.has("GenerateObstacles"):
					level_manager.updateObstacleState(details["GenerateObstacles"])
				if details.has("ObstacleGroups"):
					level_manager.updateObstacleGroups(details["ObstacleGroups"])

				level_events_status[id] = eventStatus.FINISHED
			eventTypes.CUTSCENE:
				level_events_status[id] = eventStatus.FINISHED
			eventTypes.ENDLEVEL:
				level_manager.onLevelEnd()
				level_events_status[id] = eventStatus.FINISHED
	updateReadyToProcess()

func scheduleEvent(id : String, details: Dictionary):
	get_tree().create_timer(details["Time offset"]).timeout.connect(executeEvent.bind(id,details))

func updateReadyToProcess():
	for id in level_events.keys():
		if level_events_status[id] == eventStatus.NOT_DONE:
			var ready_to_execute = true
			for ev in level_events[id]["Prerequesites"]:
				if level_events_status[ev] != eventStatus.FINISHED:
					ready_to_execute = false
			ready_to_process[id] = ready_to_execute
		

func onDialogueEnd():
	for id in level_events.keys():
		if level_events_status[id] == eventStatus.IN_PROGRESS and level_events[id]["Type"] == eventTypes.DIALOGUE:
			level_events_status[id] = eventStatus.FINISHED
			updateReadyToProcess()
