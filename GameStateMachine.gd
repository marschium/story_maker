extends Node2D

signal dialogue(text, options)
signal set_value(name, value)
signal end()

class StateNode:
    var connections = {}
    
class DialogueNode extends StateNode:
    var text = null
    
class SetValueNode extends StateNode:
    var name = null
    var value = null

export var state_dict = {}
var current_state = StateNode.new()

func _create_state(dict):
    if dict["$type"] == "dialogue":
        var s = DialogueNode.new()
        s.text = dict["text"]
        return s
    elif dict["$type"] == "set_value":
        var s = SetValueNode.new()
        s.name = dict["set_value"].keys()[0]
        s.value = dict["set_value"].values()[0]
        return s

func _connect_state(state, dict):   
    var connections = dict.get("connections")
    if connections:
        for connection_name in connections:
            var connected_state = _create_state(connections[connection_name])
            _connect_state(connected_state, connections[connection_name])
            state.connections[connection_name] = connected_state

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func setup():
    var first_state = _create_state(state_dict)
    _connect_state(first_state, state_dict)
    current_state.connections[""] = first_state
    
    
func next_state(args=[]):
    
    if not current_state.connections:
        # no more states
        emit_signal("end")
        return
    
    # process args for the current state
    # run the 'enter' for the next state
    if current_state.connections.has(""):
        # ignore any args and just move to next
        current_state = current_state.connections[""]
    else:
        # compare the args and find the correct option
        print("got state args ", args)
        current_state = current_state.connections[args[0]]
    process_state(current_state, args)
    
func process_state(state, args=[]):
    if state is DialogueNode:
        emit_signal("dialogue", state.text, state.connections.keys())
    elif state is SetValueNode:
        emit_signal("set_value", state.name, state.value)
    
