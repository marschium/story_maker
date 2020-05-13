extends Node2D

export var load_path = ""

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
	
