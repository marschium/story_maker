extends Node2D

var editor_element = preload("res://EditorElement.tscn")
var editor_element_class = preload("res://EditorElement.gd")

# Called when the node enters the scene tree for the first time.
func _ready():    
    pass
    
func _on_PictureDownload_image_picked(image):
    var e = editor_element.instance()
    e.set_name("EditorElement")
    e.initalise(image)
    add_child(e)

func get_scene_to_save():
    var root = Node2D.new()
    for child in get_children():
        if child is editor_element_class:
            var c = child.get_item_to_save()
            root.add_child(c)
            c.set_owner(root)
    return root
    
func save_resources_to_packer(packer):    
    for child in get_children():
        if child is editor_element_class:
            child.save_resources_to_packer(packer)
