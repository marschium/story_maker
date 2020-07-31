extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    if OS.has_feature('__editor__'):
        print("running editor")
        get_tree().change_scene("res://Editor.tscn")
    else:
        print("running runner")
        get_tree().change_scene("res://GameRunner.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
