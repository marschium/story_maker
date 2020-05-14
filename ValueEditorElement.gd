extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_name():
	return $NameEdit.text
	
func get_value():
	return $ValueEdit.text
