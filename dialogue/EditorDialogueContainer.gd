extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var dialogue_label = preload("res://dialogue/DialogueLabel.tscn")

var dialogue_idx = -1

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func add_text(text):
    for c in get_children():
        c.visible = false
    var d = dialogue_label.instance()
    d.text_to_show = text
    d.text = text + str(dialogue_idx)
    add_child(d)
    d.set_process(false)
    dialogue_idx += 1
    
func change_text(text):
    # TODO only update the current enabled child
    if get_child_count() > 0:
        var d = get_children()[dialogue_idx]
        d.text_to_show = text
        d.text = text
        
func show_next():    
    for c in get_children():
        c.visible = false
    dialogue_idx += 1
    if dialogue_idx >= get_child_count():
        dialogue_idx = get_child_count() - 1
    get_children()[dialogue_idx].visible = true

func show_prev():
    for c in get_children():
        c.visible = false
    dialogue_idx -= 1    
    if dialogue_idx < 0:
        dialogue_idx = 0
    get_children()[dialogue_idx].visible = true
