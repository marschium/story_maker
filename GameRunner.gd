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
    dialogue_node.connect("dialogue_finished", self, "_on_Dialogue_finished")
    
    state_machine_node = find_node("GameStateMachine", true, false)
    state_machine_node.connect("dialogue", dialogue_node, "show_dialogue")
    
func _process(delta):
    if not started:
        started = true
        state_machine_node.next_state()

func _on_Dialogue_finished(option_selected):    
    state_machine_node.next_state([option_selected])
