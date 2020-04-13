extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var world = null

# Called when the node enters the scene tree for the first time.
func _ready():
    world = $VBoxContainer/HBoxContainer/ViewportContainer/Viewport/World


func _on_Button_pressed():
    var scene_to_save = world.get_scene_to_save()
    var packed_scene = PackedScene.new()
    packed_scene.pack(scene_to_save)
    ResourceSaver.save("user://world.tscn", packed_scene)
    
    var packer = PCKPacker.new()
    packer.pck_start("user://game.pck")
    packer.add_file("res://main.tscn", "user://world.tscn")
    world.save_resources_to_packer(packer)
    packer.flush()
