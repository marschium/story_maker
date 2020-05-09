extends GraphNode


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var option_idx = 1

var dialogue_out = 0
var dialogue_in = 1
var dialogue_in_slot_type = 1
var dialogue_out_slot_type = 2

# Called when the node enters the scene tree for the first time.
func _ready():
    set_slot(dialogue_out, true, dialogue_in_slot_type, Color(1, 1, 1), true, dialogue_out_slot_type, Color(0, 1, 0)) 

func get_text():
    return $TextEdit.text


func _on_AddOptionButton_pressed():
    set_slot(dialogue_out, true, dialogue_in_slot_type, Color(1, 1, 1), false, dialogue_out_slot_type, Color(0, 1, 0)) 
    var label = LineEdit.new()
    add_child(label)
    move_child(label, get_child_count() - 2)
    set_slot(option_idx, false, dialogue_in_slot_type, Color(0, 1, 1), true, dialogue_out_slot_type, Color(1, 1, 0))
    option_idx += 1
