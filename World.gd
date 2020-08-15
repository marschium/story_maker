extends Node2D

var editor_element = preload("res://EditorElement.tscn")
var editor_element_class = preload("res://EditorElement.gd")

var z_limits = Vector2(0, 0)
var current_scene_idx = 0
var current_scene = null

var hovered_elements = []
var current_selected_element = null

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
    
func reorder_scene_children():
    for child in current_scene.get_children():
        #child.set_layer(current_scene.get_child_count() - child.get_index())
        child.find_node("Sprite").z_index = current_scene.get_child_count() - child.get_index()
        
func _input(event):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed():
        if hovered_elements.size() > 0:
            var selected = null
            for e in hovered_elements:
                if not selected or e.get_index() < selected.get_index():
                    selected = e
            if selected != null:
                current_selected_element = selected
                selected.set_selected(true)
                get_tree().set_input_as_handled()
            
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and not event.is_pressed() \
    and current_selected_element:
        current_selected_element.set_selected(false)
        current_selected_element = null
        get_tree().set_input_as_handled()
    
    
func _on_PictureDownload_image_picked(image):
    var e = editor_element.instance()
    e.set_name("EditorElement")
    e.initalise(image)
    current_scene.add_child(e)
    current_scene.move_child(e, 0)
    e.connect("mouse_entered", self, "_on_EditorElement_mouse_entered", [e])
    e.connect("removed", self, "_on_EditorElement_tree_exit", [e])
    e.connect("mouse_exited", self, "_on_EditorElement_mouse_exited", [e])
    e.connect("z_index_changed", self, "_on_EditorElement_z_index_changed", [e])
    reorder_scene_children()
    
func _on_EditorElement_tree_exit(e):
    current_selected_element = null
    _on_EditorElement_mouse_exited(e)
    remove_child(e)
    
func _on_EditorElement_mouse_entered(e):
    hovered_elements.append(e)
    
func _on_EditorElement_mouse_exited(e):
    var i = hovered_elements.find(e)
    if i >= 0:
        hovered_elements.remove(i)
        

func _on_EditorElement_z_index_changed(delta, e):
    if delta > 0 :
      current_scene.move_child(e, e.get_index() - 1)
    else:
      current_scene.move_child(e, e.get_index() + 1)
    reorder_scene_children()
