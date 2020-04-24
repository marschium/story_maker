extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var keyword = ""

onready var dialogue_label = preload("res://dialogue/DialogueLabel.tscn")

signal keyword_selected(word)


# Called when the node enters the scene tree for the first time.
func _ready():
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 6)
    rect_position = Vector2(0, view_size.y - rect_size.y)

func add_text(text):
    var d = dialogue_label.instance()
    d.text_to_show = text
    d.text = text
    add_child(d)
    d.set_process(false)
    
func change_text(text):
    # TODO only update the current enabled child
    var d = get_children()[0]
    d.text_to_show = text
    d.text = text
    
func get_dialogue_to_save():
    var dialogues = []
    for child in get_children():
        var dialogue = child.duplicate()
        dialogue.text = ""
        dialogues.append(dialogue)
    return dialogues
