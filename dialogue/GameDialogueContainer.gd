extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dialogue_idx = 0


# Called when the node enters the scene tree for the first time.
func _ready():    
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 6)
    rect_position = Vector2(0, view_size.y - rect_size.y)
    
    for c in get_children():
        c.set_process(false)
        c.visible = false
        c.connect("finished", self, "_on_Dialogue_finished")
        
    get_children()[0].set_process(true)
    get_children()[0].visible = true
        
func _on_Dialogue_finished():
    # TODO wait for input e.t.c.
    var idx = dialogue_idx
    dialogue_idx += 1
    if dialogue_idx < get_child_count():
        get_children()[idx].set_process(false)
        get_children()[idx].visible = false
        get_children()[dialogue_idx].set_process(true)
        get_children()[dialogue_idx].visible = true
    
