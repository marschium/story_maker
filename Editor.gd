extends Node2D


onready var world = $VBoxContainer/HBoxContainer/ViewportContainer/Viewport/World  
onready var tab_container = $VBoxContainer/HBoxContainer/TabContainer

func _ready():
    pass

func _export_game():
    var scene_to_save = world.get_scene_to_save()
    var packed_scene = PackedScene.new()
    packed_scene.pack(scene_to_save)
    ResourceSaver.save("user://world.tscn", packed_scene)
    
    var packer = PCKPacker.new()
    packer.pck_start("user://game.pck")
    packer.add_file("res://main.tscn", "user://world.tscn")
    world.save_resources_to_packer(packer)
    packer.flush()

func _on_MenuButton_save_selected():
    _export_game()
