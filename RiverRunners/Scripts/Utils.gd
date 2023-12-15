extends Node

const tilesize = 380

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
	print("Play sound, ", audiostream)