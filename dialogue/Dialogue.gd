extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal add_dialogue(text)
signal set_dialogue(text)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Button_pressed():
    emit_signal("add_dialogue", "hello world i am an example")
    $"VBoxContainer/Button".set_process(false)
    $"VBoxContainer/Button".visible = false
    $"VBoxContainer/TemplateScrollContainer".visible = true

func _on_Template_selected(text):
    emit_signal("set_dialogue", text)
