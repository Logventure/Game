extends Node
class_name Utils

#returns the position of a tile relative to the position of a reference tile
static func gridRelativePosition(position, tilesX, tilesY, tilesize):
	var position_x = position.x + tilesX*tilesize/2 + tilesY*tilesize/2
	var position_y = position.y - tilesY*tilesize/4 + tilesX*tilesize/4
	return Vector2(position_x, position_y)

#returns how many items the 2 arrays have in common
static func arrayHasItemsInCommon(array1: Array, array2: Array):
	var count = 0
	for item in array1:
		if array2.has(item):
			count+=1
	return count
