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

enum eventTypes {DIALOGUE, SETVALUES, TUTORIAL, CUTSCENE, ENDLEVEL}

var level_events = {}

var levels = {
	"level_1" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [101], "Characters" : ["beaver","frog","otter","crab","salmon"]},
				"chat1"         :    {"Time offset" : 1,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/anotherdialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"speedUp1"      :    {"Time offset" : 5,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"disableObs"    :    {"Time offset" : 10,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"endCutscene"   :    {"Time offset" : 7,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.CUTSCENE,    "File": "whatever"},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["endCutscene"],   "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/enddialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},

	"level_2" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : []},
				"chat1"         :    {"Time offset" : 1,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/anotherdialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"disableObs"    :    {"Time offset" : 20,   "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"endCutscene"   :    {"Time offset" : 3,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.CUTSCENE,    "File": "whatever"},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["endCutscene"],   "Type" : eventTypes.ENDLEVEL,	  "WaitForObstacleEnd": true},
	},

	"level_3" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 5, "ObstacleGroups" : [100]},
				"chat1"         :    {"Time offset" : 1,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/testdialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"endCutscene"   :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.CUTSCENE,    "File": "whatever"},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["endCutscene"],   "Type" : eventTypes.ENDLEVEL,	  "WaitForObstacleEnd": true},
	},
	
	"level_justin" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [10], "Characters" : ["beaver"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/JustinLevel1Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "move"},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 2},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/JustinLevel1ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_frog" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [120], "Characters" : ["beaver","frog"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/FrogLevel2Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"      :    {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "jump"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [10,20]},
				"speedUp1"      :    {"Time offset" : 10,   "Prerequesites" : ["levelStart"],   "Type" : eventTypes.SETVALUES,   "Speed" : 2},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/FrogLevel2ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
		
	"level_salmon" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 3, "ObstacleGroups" : [130], "Characters" : ["beaver","frog","salmon"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/SalmonLevel3Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "dash"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [10,20,30]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/SalmonLevel3ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_crab" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 3, "ObstacleGroups" : [140], "Characters" : ["beaver","frog","salmon","crab"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/CrabLevel4Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "shield"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [10,20,30,40]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],   "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/CrabLevel4ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_otter" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 4, "ObstacleGroups" : [150], "Characters" : ["beaver","frog","salmon","crab","otter"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/OtterLevel5Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "throw"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [10,20,30,40,50]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 5},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/OtterLevel5ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_shork" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 4, "ObstacleGroups" : [10,20,30,40,50,60], "Characters" : ["beaver","frog","salmon","crab","otter"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/ShorkLevel6Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 5},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/ShorkLevel6ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},

	"level_infinite" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [10,20,30,40,50,60], "Characters" : ["beaver","frog","salmon","crab","otter"]},
				"levelStart"    :    {"Time offset" : 1,    "Prerequesites" : [],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"speedUp3"      :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "Speed" : 5},
				
	},
	
	
	"level_justin_easy" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [11], "Characters" : ["beaver"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/JustinLevel1Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "move"},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 2},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/JustinLevel1ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_frog_easy" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [120], "Characters" : ["beaver","frog"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/FrogLevel2Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "jump"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [11,21]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 2},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/FrogLevel2ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
		
	"level_salmon_easy" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 3, "ObstacleGroups" : [130], "Characters" : ["beaver","frog","salmon"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/SalmonLevel3Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "dash"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [11,21,31]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/SalmonLevel3ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_crab_easy" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 3, "ObstacleGroups" : [140], "Characters" : ["beaver","frog","salmon","crab"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/CrabLevel4Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "shield"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [11,21,31,41]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],   "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/CrabLevel4ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_otter_easy" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 4, "ObstacleGroups" : [150], "Characters" : ["beaver","frog","salmon","crab","otter"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/OtterLevel5Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "throw"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [11,21,31,41,51]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 5},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/OtterLevel5ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_shork_easy" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 4, "ObstacleGroups" : [11,21,31,41,51,61], "Characters" : ["beaver","frog","salmon","crab","otter"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/ShorkLevel6Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 5},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/ShorkLevel6ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},

	
	"level_justin_hard" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [10,12], "Characters" : ["beaver"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/JustinLevel1Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "move"},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 2},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/JustinLevel1ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_frog_hard" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 2, "ObstacleGroups" : [120], "Characters" : ["beaver","frog"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/FrogLevel2Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "jump"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [12,22]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 2},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/FrogLevel2ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
		
	"level_salmon_hard" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 3, "ObstacleGroups" : [130], "Characters" : ["beaver","frog","salmon"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/SalmonLevel3Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "dash"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [12,22,32]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/SalmonLevel3ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_crab_hard" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 3, "ObstacleGroups" : [140], "Characters" : ["beaver","frog","salmon","crab"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/CrabLevel4Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "shield"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [12,22,32,42]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 3},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],   "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/CrabLevel4ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_otter_hard" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 4, "ObstacleGroups" : [150], "Characters" : ["beaver","frog","salmon","crab","otter"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/OtterLevel5Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"tutorial"    :    	 {"Time offset" : 1,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.TUTORIAL,   "Ability" : "throw"},
				"endtutorial"   :    {"Time offset" : 3,    "Prerequesites" : ["chat1"],        "Type" : eventTypes.SETVALUES,   "ObstacleGroups" : [12,22,32,42,52]},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 5},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/OtterLevel5ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	"level_shork_hard" :	{"setup"        :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false, "Speed" : 4, "ObstacleGroups" : [12,22,32,42,52,62], "Characters" : ["beaver","frog","salmon","crab","otter"]},
				"chat1"         :    {"Time offset" : 0,    "Prerequesites" : [],                "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/ShorkLevel6Dialogue.txt"},
				"levelStart"    :    {"Time offset" : 0,    "Prerequesites" : ["chat1"],         "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : true},
				"speedUp1"      :    {"Time offset" : 10,    "Prerequesites" : ["levelStart"],    "Type" : eventTypes.SETVALUES,   "Speed" : 4},
				"speedUp2"      :    {"Time offset" : 20,   "Prerequesites" : ["speedUp1"],      "Type" : eventTypes.SETVALUES,   "Speed" : 5},
				"disableObs"    :    {"Time offset" : 30,   "Prerequesites" : ["speedUp2"],      "Type" : eventTypes.SETVALUES,   "GenerateObstacles" : false},
				"chat2"         :    {"Time offset" : 1,    "Prerequesites" : ["disableObs"],    "Type" : eventTypes.DIALOGUE,    "File": "res://TextFiles/Dialogues/ShorkLevel6ENDDialogue.txt", "WaitForObstacleEnd": true},
				"levelend"      :    {"Time offset" : 1,    "Prerequesites" : ["chat2"],   		 "Type" : eventTypes.ENDLEVEL},
	},
	
	
}

#don't change anything below this line

var level_manager = null

enum eventStatus {NOT_DONE, IN_PROGRESS, FINISHED}

var level_events_status = {}
var ready_to_process = {}

var paused = false

var activeTimers = {}

var progress = 0

func _init(manager, level_id):
	level_manager = manager
	level_events = levels[level_id]

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

	Events.connect("pause_game", onPause)
	Events.connect("resume_game", onResume)


func _process(delta):
	if not paused:
		processEvents()
		updateProgress()


func processEvents():
	for id in level_events.keys():
		if level_events_status[id] == eventStatus.NOT_DONE and ready_to_process[id] == true:
			if level_events[id]["Time offset"] == 0:
				executeEvent(id, level_events[id])
			elif not activeTimers.keys().has(id):
				scheduleEvent(id, level_events[id])

func executeEvent(id : String, details: Dictionary):
	if level_manager != null and level_events_status[id] == eventStatus.NOT_DONE:
		match details["Type"]:
			eventTypes.DIALOGUE:
				print("Dialogue event: ", id, details)
				if details.has("File"):
					if details.has("WaitForObstacleEnd"):
						level_manager.onStartDialogue(details["File"],details["WaitForObstacleEnd"])
					else:
						level_manager.onStartDialogue(details["File"],false)
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
				if details.has("Characters"):
					level_manager.setCharacters(details["Characters"])

				level_events_status[id] = eventStatus.FINISHED
			eventTypes.CUTSCENE:
				level_events_status[id] = eventStatus.FINISHED
			eventTypes.TUTORIAL:
				if details.has("Ability"):
					Events.emit_signal("showTutorial",details["Ability"])
				level_events_status[id] = eventStatus.FINISHED
			eventTypes.ENDLEVEL:
				if details.has("WaitForObstacleEnd"):
					level_manager.onLevelEnd(details["WaitForObstacleEnd"])
				else:
					level_manager.onLevelEnd(false)
				level_events_status[id] = eventStatus.FINISHED
	updateReadyToProcess()

func scheduleEvent(id : String, details: Dictionary):
	var new_timer = Timer.new()
	new_timer.one_shot = true
	new_timer.autostart = true
	new_timer.wait_time = details["Time offset"]
	new_timer.timeout.connect(onTimerEnd.bind(new_timer,id,details))
	activeTimers[id] = new_timer
	add_child(new_timer)

func onTimerEnd(timer: Timer,id : String, details: Dictionary):
	activeTimers.erase(id)
	timer.queue_free()
	executeEvent(id,details)

func updateReadyToProcess():
	for id in level_events.keys():
		if level_events_status[id] == eventStatus.NOT_DONE:
			var ready_to_execute = true
			for ev in level_events[id]["Prerequesites"]:
				if level_events_status[ev] != eventStatus.FINISHED:
					ready_to_execute = false
			ready_to_process[id] = ready_to_execute
		
func onPause():
	paused = true
	updateTimersState()

func onResume():
	paused = false
	updateTimersState()

func updateTimersState():
	for timer in activeTimers.values():
		if timer is Timer:
			timer.paused = paused

func onDialogueEnd():
	for id in level_events.keys():
		if level_events_status[id] == eventStatus.IN_PROGRESS and level_events[id]["Type"] == eventTypes.DIALOGUE:
			level_events_status[id] = eventStatus.FINISHED
			updateReadyToProcess()

func isEndless():
	var endless = true
	for id in level_events.keys():
		if level_events[id]["Type"] == eventTypes.ENDLEVEL:
			endless = false
	return endless

func updateProgress():
	var total = 0
	var completed = 0
	for id in level_events.keys():
		total += level_events[id]["Time offset"]

		if level_events_status[id] == eventStatus.NOT_DONE:
			if activeTimers.keys().has(id):
				completed += level_events[id]["Time offset"] - activeTimers[id].time_left

		if level_events_status[id] == eventStatus.FINISHED:
			completed += level_events[id]["Time offset"]

	if total > 0 and completed > 0:
		if completed/total > 0:
			progress = completed/total * 100

func getProgress():
	return progress
