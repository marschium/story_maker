extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal set_dialogue(text)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_Template_selected(text):
    emit_signal("set_dialogue", text)
