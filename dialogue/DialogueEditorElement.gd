extends PanelContainer

var dialogue_container = null
var dialogue_label = preload("res://dialogue/DialogueLabel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var view_size = get_viewport().size
	rect_size = Vector2(view_size.x, view_size.y / 3)
	rect_position = Vector2(0, view_size.y - rect_size.y)
	dialogue_container = $"VBoxContainer/EditorDialogueContainer"

func add_text(text):
	dialogue_container.add_text(text)
	$"VBoxContainer/HBoxContainer/CountLabel".text = str(dialogue_container.dialogue_idx + 1) + "/" + str(dialogue_container.get_child_count())
	
func change_text(text):
	dialogue_container.change_text(text)

func get_dialogue():
	return $DialogueGraphCreator.get_dialogue()
 
