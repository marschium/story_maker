extends "res://logic/LogicGraphNode.gd"

func _ready():
    set_slot(dialogue_out, true, dialogue_in_slot_type, Color(1, 1, 1), true, dialogue_out_slot_type, Color(0, 1, 0)) 

func to_dict():
    return {
        "$type": "dialogue",
        "text": $TextEdit.text,
        "connections": {}
    }

func _on_AddOptionButton_pressed():
    has_options = true
    set_slot(dialogue_out, true, dialogue_in_slot_type, Color(1, 1, 1), false, dialogue_out_slot_type, Color(0, 1, 0)) 
    var label = LineEdit.new()
    add_child(label)
    move_child(label, get_child_count() - 2)
    set_slot(option_idx, false, dialogue_in_slot_type, Color(0, 1, 1), true, dialogue_out_slot_type, Color(1, 1, 0))
    option_idx += 1
