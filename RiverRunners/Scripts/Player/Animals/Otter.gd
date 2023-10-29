extends Sprite2D

var animal
var destination = Vector2.ZERO
var dest = Vector2.ZERO
var deltaTime = 0
var delay = 2
var array = {}
var array1 = {}

func _ready():
    animal = Animal.new() 
    Events.connect("input_jump", jump)

func jump():
    array = animal.jump(position, delay)
    destination = array[0]
    deltaTime = array[1]
    dest = array[0]

func fall():
    array1 = animal.fall(position, delay)
    destination = array1[0]
    deltaTime = array1[1]

func throw():
    pass

func _process(delta):
    position = position.move_toward(destination, deltaTime)
    if(position == dest):
        fall()