extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    var file2Check = File.new()
    if file2Check.file_exists("res://editor.txt"):
        print_debug("running editor")
        get_tree().change_scene("res://Editor.tscn")
    else:
        print("running runner")
        get_tree().change_scene("res://GameRunner.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
