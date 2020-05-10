extends PanelContainer


var ValueEditorElement = load("res://ValueEditorElement.tscn")


func _ready():
    pass # Replace with function body.


func _on_Button_pressed():
    var v = ValueEditorElement.instance()
    $VBoxContainer/ScrollContainer/VBoxContainer.add_child(v)
