extends Node

func _process(delta):
    handleKeyboardInput()

func handleKeyboardInput():
    if Input.is_action_just_pressed("dashRight"):
        Events.emit_signal("input_dash_right")
        print("dash r")
    elif Input.is_action_just_pressed("dashLeft"):
        Events.emit_signal("input_dash_left")
        print("dash l")
    elif Input.is_action_pressed("left"):
        Events.emit_signal("input_move_left")
        print("left")
    elif Input.is_action_pressed("right"):
        Events.emit_signal("input_move_right")
        print("right")
    elif Input.is_action_just_pressed("jump"):
        Events.emit_signal("input_jump")
        print("jump")
    elif Input.is_action_just_pressed("throw"):
        Events.emit_signal("input_throw")
        print("throw")
    elif Input.is_action_just_pressed("shield"):
        Events.emit_signal("input_shield")
        print("shield")
    elif Input.is_action_just_pressed("ui_cancel"):
        Events.emit_signal("pause_game")
    
func handleControllerInput():
    pass
    
    
    