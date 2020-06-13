extends Node2D

var editor_element = preload("res://EditorElement.tscn")
var editor_element_class = preload("res://EditorElement.gd")

var current_scene_idx = 0
var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():    
    current_scene = get_child(current_scene_idx)
    
func add_scene():
    current_scene.visible = false
    
    current_scene_idx += 1
    var s = Node2D.new()
    current_scene = s
    add_child(s)
    
func change_to_scene(id):
    current_scene.visible = false
    current_scene_idx = id
    current_scene = get_child(current_scene_idx)
    current_scene.visible = true

func get_scene_to_save():
    var root = Node2D.new()
    for scene in get_children():
        for child in scene.get_children():
            if child is editor_element_class:
                var c = child.get_item_to_save()
                root.add_child(c)
                c.set_owner(root)
    return root
    
func save_resources_to_packer(packer):   
    for scene in get_children(): 
        for child in scene.get_children():
            if child is editor_element_class:
                child.save_resources_to_packer(packer)
            
#func _unhandled_input(event):
#    if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN:
#        scale -= Vector2(0.1, 0.1)
#    elif event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP:
#        scale += Vector2(0.1, 0.1)

func _on_PictureDownload_image_picked(image):
    var e = editor_element.instance()
    e.set_name("EditorElement")
    e.initalise(image)
    current_scene.add_child(e)
    current_scene.move_child(e, 0)
