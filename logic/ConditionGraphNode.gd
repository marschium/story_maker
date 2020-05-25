extends "res://logic/LogicGraphNode.gd"


# Called when the node enters the scene tree for the first time.
func _ready():    
    set_slot(0, true, dialogue_in_slot_type, Color(1, 1, 1), false, dialogue_out_slot_type, Color(0, 1, 0)) 
    set_slot(1, false, dialogue_in_slot_type, Color(1, 1, 1), true, dialogue_out_slot_type, Color(0, 1, 0)) 
    set_slot(2, false, dialogue_in_slot_type, Color(1, 1, 1), true, dialogue_out_slot_type, Color(0, 1, 0)) 
    $HBoxContainer/CheckOptionButton.add_item("is")
    $HBoxContainer/CheckOptionButton.add_item("is not")
    has_options = true
  
func to_dict():
    #todo trim
    return {
        "$type": "check_value",
        "check_value": {
           "value_name": $HBoxContainer/ValueToCheckEdit.text,
            "condition": "is", # todo change based on option
            "condition_value":  $HBoxContainer/ComparisonValueEdit.text
        },
        "connections": {}
    }  


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
