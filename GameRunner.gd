extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var load_path = ""


# Called when the node enters the scene tree for the first time.
func _ready():
    var res = ProjectSettings.load_resource_pack(load_path)
    var World = ResourceLoader.load("res://main.tscn")
    var world = World.instance()
    add_child(world)
