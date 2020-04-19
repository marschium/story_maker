extends MenuButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal save_selected


# Called when the node enters the scene tree for the first time.
func _ready():
    get_popup().add_item("Save")    
    get_popup().add_item("Exit")
    get_popup().connect("id_pressed", self, "item_pressed")


func item_pressed(id):
    var name = get_popup().get_item_text(id)
    if name == "Save":
        emit_signal("save_selected")
    elif name == "Exit":
        get_tree().quit()
