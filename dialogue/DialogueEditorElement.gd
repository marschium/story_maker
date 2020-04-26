extends PanelContainer

var dialogue_container = null

# Called when the node enters the scene tree for the first time.
func _ready():
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 6)
    rect_position = Vector2(0, view_size.y - rect_size.y)
    dialogue_container = $"VBoxContainer/EditorDialogueContainer"

func add_text(text):
    dialogue_container.add_text(text)
    $"VBoxContainer/HBoxContainer/CountLabel".text = str(dialogue_container.dialogue_idx + 1) + "/" + str(dialogue_container.get_child_count())
    
func change_text(text):
    dialogue_container.change_text(text)

func get_dialogue_to_save():
    var dialogues = []
    for child in dialogue_container.get_children():
        var dialogue = child.duplicate()
        dialogue.text = ""
        dialogues.append(dialogue)
    return dialogues

func _on_AddButton_pressed():
    add_text("test")  

func _on_PrevButton_pressed():
    dialogue_container.show_prev()
    $"VBoxContainer/HBoxContainer/CountLabel".text = str(dialogue_container.dialogue_idx + 1) + "/" + str(dialogue_container.get_child_count())

func _on_NextButton_pressed():
    dialogue_container.show_next()
    $"VBoxContainer/HBoxContainer/CountLabel".text = str(dialogue_container.dialogue_idx + 1) + "/" + str(dialogue_container.get_child_count())
