extends Node

const tilesize = 380
var lastUIsoundIndex = 1
var increasingIndex = false
var playtimeUI = 0

func _ready():
	pass
func _process(delta):
	playtimeUI += delta

#returns the position of a tile relative to the position of a reference tile
func gridRelativePosition(position, tilesX, tilesY, tilesize):
	var position_x = position.x + tilesX*tilesize/2 + tilesY*tilesize/2
	var position_y = position.y - tilesY*tilesize/4 + tilesX*tilesize/4
	return Vector2(position_x, position_y)

#returns how many items the 2 arrays have in common
func arrayHasItemsInCommon(array1: Array, array2: Array):
	var count = 0
	for item in array1:
		if array2.has(item):
			count+=1
	return count

func playSoundFile(parent,filepath: String,bus: String,volume = 0,positional = false):
	var audiostream = AudioStreamPlayer.new()
	if positional:
		audiostream = AudioStreamPlayer2D.new()
	var stream = AudioStreamWAV.new()
	stream = load(filepath)
	audiostream.stream = stream
	audiostream.bus = bus
	audiostream.volume_db = volume
	parent.add_child(audiostream)
	audiostream.play()
	#print("Play sound, ", audiostream)

func playUISound(parent,volume = 0):
	if playtimeUI > 0.2:
		var soundfiles = ["res://Assets/Audio/SFX/UI/UI-1.wav", "res://Assets/Audio/SFX/UI/UI-2.wav", "res://Assets/Audio/SFX/UI/UI-3.wav"]
		var index = lastUIsoundIndex
		if increasingIndex:
			if index < len(soundfiles) - 1:
				index += 1
			else:
				index -= 1
				increasingIndex = false
		else:
			if index > 0:
				index -= 1
			else:
				index += 1
				increasingIndex = true

		lastUIsoundIndex = index
		playSoundFile(self,soundfiles[index],"SFX",volume)
		playtimeUI = 0
