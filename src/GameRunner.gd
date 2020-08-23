extends Control

export var load_path = ""
var dialogue_node
var state_machine_node
var value_store
var started
var world 
var current_scene_idx = 0

# Called when the node enters the s
# Called when the node enters the scene tree for the first time.
func _ready():
    var res = ProjectSettings.load_resource_pack(load_path)
    var World = ResourceLoader.load("res://main.tscn")
    
    world = World.instance()
    add_child(world, true)
    
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
            
    # todo change images when scene changes
    
    # connect state changes to dialogue e.t.c
    dialogue_node = find_node("GameDialogueContainer", true, false)
    # todo resize/move dialogue node to bottom 1/3 of screen
    
    value_store = find_node("GameValueStore", true, false)
    
    state_machine_node = find_node("GameStateMachine", true, false)
    state_machine_node.connect("end", self, "_on_StateMachine_end")
    state_machine_node.connect("dialogue", self, "_on_StateMachine_dialogue")
    state_machine_node.connect("set_value", self, "_on_StateMachine_set_value")
    state_machine_node.connect("check_value", self, "_on_StateMachine_check_value")
    
    show_scene(0)
    
    print_debug("resizing window")
    OS.set_window_size(Vector2(1200, 900))
    
func show_scene(id):
    current_scene_idx = id
    for c in world.get_children():
        c.visible = false
    world.get_child(current_scene_idx).visible = true
    
func _process(delta):
    if not started:
        started = true
        state_machine_node.next_state()

func _on_StateMachine_dialogue(text, options):
    var res = yield(dialogue_node.show_dialogue(text, options), "completed")
    state_machine_node.next_state([res])
    
func _on_StateMachine_set_value(name, value):
    print("set ", name, " to ", value) # todo
    value_store.set(name, value)
    state_machine_node.next_state()
    
func _on_StateMachine_check_value(name, condition):
    print("checking condition on ", name)
    var res = condition.check(value_store.get(name)) 
    print("result was: ", res)
    state_machine_node.next_state([res])
        

func _on_StateMachine_end():
    print("END")
    if state_machine_node.has_scenes_to_play():
        yield(get_tree().create_timer(5), "timeout")
        show_scene(current_scene_idx + 1)
        state_machine_node.next_scene()
        state_machine_node.next_state()
