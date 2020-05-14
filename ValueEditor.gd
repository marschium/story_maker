extends PanelContainer


var ValueEditorElement = load("res://ValueEditorElement.tscn")


func _ready():
	pass # Replace with function body.

func get_values():
	var values = {}
	for i in $VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		values[i.get_name()] = i.get_value()
	return values

func _on_Button_pressed():
	var v = ValueEditorElement.instance()
	$VBoxContainer/ScrollContainer/VBoxContainer.add_child(v)
