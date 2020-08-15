extends PanelContainer

var GraphEditor = preload("res://logic/LogicGraphCreator.tscn")

var current_scene_idx = 0
var current_editor = null

# Called when the node enters the scene tree for the first time.
func _ready():
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 3)
    rect_position = Vector2(0, view_size.y - rect_size.y)
    current_editor = get_child(0)

func get_state_machine_dict():
    var res = {
        "scenes": []
    }
    for c in get_children():
        res["scenes"].append(c.get_state_machine_dict())
    return res
 
func add_scene():
    current_editor.visible = false
    var new_editor = GraphEditor.instance()
    current_scene_idx += 1
    add_child(new_editor)

func change_to_scene(id):    
    current_editor.visible = false
    current_scene_idx = id
    current_editor = get_child(current_scene_idx)
    current_editor.visible = true
