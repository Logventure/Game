class_name Animal

const tilewidth: int = 380
const tileheight: int = 190
var multiplier = 0.05
var aux = 0
var distance = Vector2.ZERO
var array = {}
var array1 = {}
var speed = 1

func jump(pos, delay):
	array[0] = Vector2(pos.x - 0, pos.y - (tileheight * 0.75))
	aux = array[0] - pos
	distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
	array[1] = speed + distance * multiplier
	
	return array

func fall(pos, delay):
	array1[0] = Vector2(pos.x - 0, pos.y + (tileheight * 0.75))
	aux = array1[0] - pos
	distance = sqrt(pow(aux.x, 2) + pow(aux.y, 2))
	array1[1] = speed + distance * multiplier
	
	return array1
