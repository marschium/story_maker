extends GraphNode

var option_idx = 1

var dialogue_out = 0
var dialogue_in = 1
var dialogue_in_slot_type = 1
var dialogue_out_slot_type = 2
var has_options = false


func slot_to_option(slot_idx):
    if not has_options:
        return ""
    return get_child(slot_idx + 1).text

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    #set_slot(dialogue_out, true, dialogue_in_slot_type, Color(1, 1, 1), true, dialogue_out_slot_type, Color(0, 1, 0)) 

func to_dict():
    pass
