extends MenuButton

signal save_selected

func _ready():
    get_popup().add_item("Export")    
    get_popup().add_item("Exit")
    get_popup().connect("id_pressed", self, "item_pressed")


func item_pressed(id):
    var name = get_popup().get_item_text(id)
    if name == "Export":
        emit_signal("save_selected")
    elif name == "Exit":
        get_tree().quit()
