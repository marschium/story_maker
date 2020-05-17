extends "res://logic/LogicGraphNode.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func get_value_name():
    return $HBoxContainer/NameEdit.text
    
func get_value():
    return $HBoxContainer/ValueEdit.text
