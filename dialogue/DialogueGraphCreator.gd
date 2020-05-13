extends Control

var node = load("res://dialogue/DialogueGraphNode.tscn")

signal dialogue_saved(dialogue)

# Called when the node enters 
# the scene tree for the first time.
func _ready():
	$VBoxContainer/GraphEdit.add_valid_connection_type(1, 2)
	$VBoxContainer/GraphEdit/DialogueStartNode.offset = Vector2(0, 32)
	pass # Replace with function body.


func _on_AddButton_pressed():
	var n = node.instance()
	n.connect("close_request", self, "_on_GraphEdit_delete_nodes_request", [n])
	$VBoxContainer/GraphEdit.add_child(n)


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	for conn in  $VBoxContainer/GraphEdit.get_connection_list():
		if conn.from == from && conn.from_port == from_slot:
			$VBoxContainer/GraphEdit.disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
	$VBoxContainer/GraphEdit.connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):    
	$VBoxContainer/GraphEdit.disconnect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_delete_nodes_request(node):
	for connection in $VBoxContainer/GraphEdit.get_connection_list():        
		var from_node = $VBoxContainer/GraphEdit.get_node(connection["from"])        
		var to_node = $VBoxContainer/GraphEdit.get_node(connection["to"])
		if from_node == node or to_node == node:
			$VBoxContainer/GraphEdit.disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
	node.queue_free()


func get_dialogue():
	
	# build dicts for all the nodes
	# build nested structure by looking at the connections
	var start_node_name = null
	var dialogue_dicts = {}
	for child in $VBoxContainer/GraphEdit.get_children():
		if child is GraphNode and child != $VBoxContainer/GraphEdit/DialogueStartNode:
			var d = {
				"text": child.get_text(),
				"options": {}
			}
			dialogue_dicts[child.name] = d
	
	var connections = $VBoxContainer/GraphEdit.get_connection_list()
	for i in range(0, len(connections)):
		var connection = connections[i]
		var from_node = $VBoxContainer/GraphEdit.get_node(connection["from"])
		var to_node = $VBoxContainer/GraphEdit.get_node(connection["to"])
		if from_node == $VBoxContainer/GraphEdit/DialogueStartNode:
			start_node_name = to_node.name
		else:
			var from_node_name = from_node.name
			var to_node_name = to_node.name
			var from_option = from_node.slot_to_option(connection["from_port"])
			dialogue_dicts[from_node_name]["options"][from_option] = dialogue_dicts[to_node_name]
	
	# TODO error if no start
	return dialogue_dicts[start_node_name]

