extends Node2D

export var load_path = ""
var dialogue_node
var state_machine_node
var started

# Called when the node enters the scene tree for the first time.
func _ready():
    var res = ProjectSettings.load_resource_pack(load_path)
    var World = ResourceLoader.load("res://main.tscn")
    var world = World.instance()
    add_child(world)
    
    var state = World.get_state()
    for idx in range(0, state.get_node_count() ):
        var node_name = state.get_node_name(idx)
        var node = find_node(node_name, true, false)
        for propIdx in range(0, state.get_node_property_count(idx) ):
            var pname = state.get_node_property_name(idx, propIdx)
            var pvalue = state.get_node_property_value(idx, propIdx)
            if pname != "script" && pname != "__meta__": # TODO ignore script?
                node.set(pname, pvalue)
        if node && node.has_method("setup"):
            node.setup()
    
    # connect state changes to dialogue e.t.c
    dialogue_node = find_node("GameDialogueContainer", true, false)
    
    state_machine_node = find_node("GameStateMachine", true, false)
    state_machine_node.connect("end", self, "_on_StateMachine_end")
    state_machine_node.connect("dialogue", self, "_on_StateMachine_dialogue")
    state_machine_node.connect("set_value", self, "_on_StateMachine_set_value")
    
func _process(delta):
    if not started:
        started = true
        state_machine_node.next_state()

func _on_StateMachine_dialogue(text, options):
    var res = yield(dialogue_node.show_dialogue(text, options), "completed")
    # todo clear
    state_machine_node.next_state([res])
    
func _on_StateMachine_set_value(name, value):
    print("set ", name, " to ", value) # todo
    state_machine_node.next_state()

func _on_StateMachine_end():
    print("END")
