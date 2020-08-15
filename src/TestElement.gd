extends Area2D

signal selected();

var hovered = true

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func _input(event):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed() \
    and self.hovered:
        emit_signal("selected")

func _on_TestElement_mouse_entered():
    self.hovered = true

func _on_TestElement_mouse_exited():
    self.hovered = false
