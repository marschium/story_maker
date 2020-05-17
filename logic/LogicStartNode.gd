extends "res://logic/LogicGraphNode.gd"


# Called when the node enters the scene tree for the first time.
func _ready():    
    set_slot(dialogue_out, false, dialogue_in_slot_type, Color(1, 1, 1), true, dialogue_out_slot_type, Color(0, 1, 0)) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
