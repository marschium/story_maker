extends "res://logic/LogicGraphNode.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
    set_slot(dialogue_out, true, dialogue_in_slot_type, Color(1, 1, 1), true, dialogue_out_slot_type, Color(0, 1, 0)) 

func to_dict():
    return {
        "$type": "set_value",
        "set_value": {
           $HBoxContainer/NameEdit.text : $HBoxContainer/ValueEdit.text
        },
        "connections": {}
    }
