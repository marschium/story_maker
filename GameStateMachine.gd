extends Node2D

signal dialogue(text, options)

class StateNode:
    var data = null
    var connections = {}

export var state_dict = {}
var current_state = StateNode.new()

func _setup_state(state, dict):    
    state.data = dict["text"]
    var connections = dict.get("options")
    if connections:
        for connection_name in connections:
            var connected_state = StateNode.new()
            _setup_state(connected_state, connections[connection_name])
            state.connections[connection_name] = connected_state

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func setup():
    var first_state = StateNode.new()
    _setup_state(first_state, state_dict)
    current_state.connections[""] = first_state
    
    
func next_state(args=[]):
    
    if not current_state.connections:
        # no more states
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
    # todo check the data/type of state
    emit_signal("dialogue", state.data, state.connections.keys()) # todo check for options
