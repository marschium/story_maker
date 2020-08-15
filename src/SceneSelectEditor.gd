extends PanelContainer

signal scene_added()
signal scene_changed(id)

var SceneSelectOption = preload("res://SceneSelectOption.tscn")

var current_scene_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    $VBoxContainer/ScrollContainer/VBoxContainer/SceneSelectOption.connect("selected", self, "_on_SceneButton_pressed", [current_scene_idx])
        
func set_current_screenshot(screenshot):
    $VBoxContainer/ScrollContainer/VBoxContainer.get_child(current_scene_idx).set_screenshot(screenshot)

func _on_Button_pressed():
    current_scene_idx += 1
    var sceneSelect = SceneSelectOption.instance()
    sceneSelect.connect("selected", self, "_on_SceneButton_pressed", [current_scene_idx])
    $VBoxContainer/ScrollContainer/VBoxContainer.add_child(sceneSelect)
    emit_signal("scene_added")    

func _on_SceneButton_pressed(id):
    current_scene_idx = id
    emit_signal("scene_changed", id)
