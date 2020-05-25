extends Node2D

signal dialogue(text, options)
signal set_value(name, value)
signal check_value(name, condition)
signal end()

class StateNode:
    var connections = {}
    
    func next_state(args=[]):
        if self.connections.has(""):
            # ignore any args and just move to next
            return self.connections[""]
        else:
            # compare the args and find the correct option
            print("got state args ", args)
            return self.connections[args[0]]
    
class DialogueNode extends StateNode:
    var text = null
    
class SetValueNode extends StateNode:
    var name = null
    var value = null
    
class ConditionNode extends StateNode:
    var name = null
    var condition = null
    
    func next_state(args=[]):
        # convert bool to string
        if args[0]:
            return .next_state(["True"])
        return .next_state(["False"])
    
class EqualCondition:  
    var value = ""
    func check(v):
        return v == value
        
class NotEqualCondition:
    var value = ""
    func check(v):
        return v != value

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
    elif dict["$type"] == "check_value":
        var s = ConditionNode.new()
        s.name = dict["check_value"]["value_name"] # todo support multiple checks
        if dict["check_value"]["condition"] == "is":
            s.condition = EqualCondition.new()
            s.condition.value = dict["check_value"]["condition_value"]
        else:
            pass # todo other conditions
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
    
    current_state = current_state.next_state(args)
    process_state(current_state, args)
    
func process_state(state, args=[]):
    if state is DialogueNode:
        emit_signal("dialogue", state.text, state.connections.keys())
    elif state is SetValueNode:
        emit_signal("set_value", state.name, state.value)
    elif state is ConditionNode:
        emit_signal("check_value", state.name, state.condition)
    
