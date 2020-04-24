extends Node2D

var editor_element = preload("res://EditorElement.tscn")
var editor_element_class = preload("res://EditorElement.gd")

var dialogue_container = preload("res://dialogue/DialogueContainer.tscn")
var dialogue_element = preload("res://dialogue/DialogueEditorElement.tscn")
var dialogue_element_class = preload("res://dialogue/DialogueEditorElement.gd")

# Called when the node enters the scene tree for the first time.
func _ready():    
    pass
    

func get_scene_to_save():
    var root = Node2D.new()
    var dc = dialogue_container.instance()
    root.add_child(dc)
    dc.set_owner(root)
    for child in get_children():
        if child is editor_element_class:
            var c = child.get_item_to_save()
            root.add_child(c)
            c.set_owner(root)
        elif child is dialogue_element_class:
            var dialogues = child.get_dialogue_to_save()
            # TODO setup ordering and auto swap to next item
            dc.add_child(dialogues[0])
            dialogues[0].set_owner(root)
    return root
    
func save_resources_to_packer(packer):    
    for child in get_children():
        if child is editor_element_class:
            child.save_resources_to_packer(packer)

func _on_PictureDownload_image_picked(image):
    var e = editor_element.instance()
    e.set_name("EditorElement")
    e.initalise(image)
    add_child(e)

func _on_Dialogue_add_dialogue(text):
    var d = dialogue_element.instance()
    d.set_name("DialogueEditorElement")
    add_child(d)
    d.add_text(text)

func _on_Words_set_dialogue(text):
    $DialogueEditorElement.change_text(text)
