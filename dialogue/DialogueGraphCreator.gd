extends Control

var node = load("res://dialogue/DialogueGraphNode.tscn")

signal dialogue_saved(dialogue)

# Called when the node enters 
# the scene tree for the first time.
func _ready():
    $VBoxContainer/GraphEdit.add_valid_connection_type(1, 2)
    pass # Replace with function body.


func _on_AddButton_pressed():
    $VBoxContainer/GraphEdit.add_child(node.instance())


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
    for conn in  $VBoxContainer/GraphEdit.get_connection_list():
        if conn.from == from && conn.from_port == from_slot:
            $VBoxContainer/GraphEdit.disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
    $VBoxContainer/GraphEdit.connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):    
    $VBoxContainer/GraphEdit.disconnect_node(from, from_slot, to, to_slot)


func _on_SaveButton_pressed():
    emit_signal("dialogue_saved", get_dialogue())

func get_dialogue():
    
    # build dicts for all the nodes
    # build nested structure by looking at the connections
    var dialogue_dicts = {}
    for child in $VBoxContainer/GraphEdit.get_children():
        if child is GraphNode:
            var d = {
                "text": child.get_text(),
                "options": {}
            }
            dialogue_dicts[child.name] = d
    
    var connections = $VBoxContainer/GraphEdit.get_connection_list()
    for i in range(0, len(connections)):
        var connection = connections[i]
        var from_node_name = $VBoxContainer/GraphEdit.get_node(connection["from"]).name
        var to_node_name = $VBoxContainer/GraphEdit.get_node(connection["to"]).name
        # TODO look at the port and determine if text is set
        dialogue_dicts[from_node_name]["options"][""] = dialogue_dicts[to_node_name]
    
    # TODO get the start node
    return dialogue_dicts[dialogue_dicts.keys()[0]]
    
    
