extends PanelContainer

signal scene_added()
signal scene_changed(id)

var current_scene_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    $VBoxContainer/ScrollContainer/VBoxContainer/Button.connect("pressed", self, "_on_SceneButton_pressed", [current_scene_idx])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Button_pressed():
    current_scene_idx += 1
    var sceneButton = Button.new() 
    sceneButton.text = "Scene %d" % (current_scene_idx + 1)
    sceneButton.connect("pressed", self, "_on_SceneButton_pressed", [current_scene_idx])
    $VBoxContainer/ScrollContainer/VBoxContainer.add_child(sceneButton)
    emit_signal("scene_added")

func _on_SceneButton_pressed(id):
    emit_signal("scene_changed", id)
