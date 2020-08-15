extends Control

var dialogue_node = load("res://logic/DialogueGraphNode.tscn")
var set_value_node = load("res://logic/SetValueGraphNode.tscn")
var condition_node = load("res://logic/ConditionGraphNode.tscn")

signal dialogue_saved(dialogue)

# Called when the dialogue_node enters 
# the scene tree for the first time.
func _ready():
    $VBoxContainer/GraphEdit.add_valid_connection_type(1, 2)
    $VBoxContainer/GraphEdit/LogicStartNode.offset = Vector2(0, 32)
    pass # Replace with function body.


func _on_AddDialogueButton_pressed():
    var n = dialogue_node.instance()
    n.connect("close_request", self, "_on_GraphEdit_delete_nodes_request", [n])
    $VBoxContainer/GraphEdit.add_child(n)  


func _on_AddSetValueButton_pressed():
    var n = set_value_node.instance()
    n.connect("close_request", self, "_on_GraphEdit_delete_nodes_request", [n])
    $VBoxContainer/GraphEdit.add_child(n) 

func _on_AddConditionButton_pressed():
    var n = condition_node.instance()
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


func get_state_machine_dict():
    
    # build dicts for all the dialogue_nodes
    # build nested structure by looking at the connections
    var start_node_name = null
    var states_dict = {}
    for child in $VBoxContainer/GraphEdit.get_children():
        if child == $VBoxContainer/GraphEdit/LogicStartNode:
            continue
        if child.has_method("to_dict"): # TODO can check if LogicGraphNode?
            var d = child.to_dict()
            states_dict[child.name] = d
    
    var connections = $VBoxContainer/GraphEdit.get_connection_list()
    for i in range(0, len(connections)):
        var connection = connections[i]
        var from_node = $VBoxContainer/GraphEdit.get_node(connection["from"])
        var to_node = $VBoxContainer/GraphEdit.get_node(connection["to"])
        if from_node == $VBoxContainer/GraphEdit/LogicStartNode:
            start_node_name = to_node.name
        else:
            var from_node_name = from_node.name
            var to_node_name = to_node.name
            var from_option = from_node.slot_to_option(connection["from_port"])
            states_dict[from_node_name]["connections"][from_option] = states_dict[to_node_name]
    
    # TODO error if no start
    return states_dict[start_node_name]

