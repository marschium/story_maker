extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 3)
    rect_position = Vector2(0, view_size.y - rect_size.y)

func get_state_machine_dict():
    return $LogicGraphCreator.get_state_machine_dict()
 
