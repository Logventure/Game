extends Sprite2D

var animal
var destination = Vector2.ZERO
var deltaTime = 0
var delay = 1

func _ready():
    animal = Animal.new() 
    Events.connect("input_jump", jump)

func jump():
    var array
    array = animal.jump(position, delay)
    destination = array[0]
    deltaTime = array[1]

func _process(delta):
    position = position.move_toward(destination, deltaTime)